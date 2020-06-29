//
//  SecureEnclave.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/23/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation

enum KeyError: Error {
  case failedToDecrypt, unableToLoadKey
}

struct SecureEnclave {
  static let shared = SecureEnclave()
  
  private var privateKey: SecKey?
  private var publicKey: SecKey?
  
  let keyTag = "LreHjoPkM5uUJl2lGVL3"
  
  let access =
  SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                  kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                  [.privateKeyUsage],//, .biometryCurrentSet],
                                  nil)!   // Ignore error
  
  lazy var attributes: [String: Any] = {
    var attributes: [String: Any] = [
      kSecAttrKeyType as String:            kSecAttrKeyTypeEC,
      kSecAttrKeySizeInBits as String:      256,
      kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String:      true,
        kSecAttrApplicationTag as String:   keyTag,
        kSecAttrAccessControl as String:    access
      ]
    ]
    
    #if targetEnvironment(simulator)
    #else
    attributes[kSecAttrTokenID as String] = kSecAttrTokenIDSecureEnclave
    #endif
    
    return attributes
  }()
  
  init() {
    do {
      try loadKey()
    } catch {
      do {
        try createKey()
      } catch {
        
      }
    }
  }
  
  mutating private func createKey() throws {
    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
        throw error!.takeRetainedValue() as Error
    }
    
    publicKey = SecKeyCopyPublicKey(privateKey)
    self.privateKey = privateKey
  }
  
  mutating private func loadKey() throws {
    var key: CFTypeRef?
    let status = SecItemCopyMatching(attributes as CFDictionary, &key)
    
    guard status == errSecSuccess else {
      throw KeyError.unableToLoadKey
    }
    
    let secKey = key as! SecKey
    publicKey = SecKeyCopyPublicKey(secKey)
    privateKey = secKey
  }
  
  func encrypt(plainText: String) throws -> NSData {
    guard let publicKey = publicKey else { throw NSError() }
    var error: Unmanaged<CFError>?
    guard let cyphertext = SecKeyCreateEncryptedData(publicKey,
                                               .eciesEncryptionCofactorX963SHA256AESGCM,
                                               plainText.data(using: .utf8)! as CFData,
                                               &error) else {
                                                print(error)
                                                throw error!.takeRetainedValue() as Error
    }

    return cyphertext as NSData
  }
  
  func decrypt(cyphertext: NSData) throws -> String {
    guard let privateKey = privateKey else { throw NSError() }
    var error: Unmanaged<CFError>?
    guard let plaintextData = SecKeyCreateDecryptedData(privateKey, .eciesEncryptionCofactorX963SHA256AESGCM, cyphertext, &error) else {
      print(error)
      throw error!.takeRetainedValue() as Error
    }
    
    guard let plaintext = String(data: plaintextData as Data, encoding: .utf8) else {
      throw NSError()
    }
    
    return plaintext
  }
}
