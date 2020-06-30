//
//  SecureEnclave.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/23/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit

enum KeyError: Error {
  case failedToDecrypt, unableToLoadKey
}

class SecureEnclave {
  static var shared = SecureEnclave()
  
  private var privateKey: SecKey?
  private var publicKey: SecKey?
  
  let keyTag = "LreHjoPkMd5uUJl7lGVI4"
  
  lazy var access =
  SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                  kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                  [.privateKeyUsage, .userPresence],
                                  nil)!   // Ignore error
  
  lazy var attributes: [String: Any] = {
    var attributes: [String: Any] = [
      kSecAttrKeyType as String:            kSecAttrKeyTypeEC,
      kSecAttrKeySizeInBits as String:      256,
      kSecUseAuthenticationContext as String: context,
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
  
  private func getKeys() {
    do {
      try loadKey()
    } catch {
      do {
        try createKey()
      } catch {
        
      }
    }
  }
  
  func dropKeys() {
    privateKey = nil
    publicKey = nil
  }
  
  private func createKey() throws {
    var error: Unmanaged<CFError>?
    guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
        throw error!.takeRetainedValue() as Error
    }
    
    publicKey = SecKeyCopyPublicKey(privateKey)
    self.privateKey = privateKey
  }
  
  private let context = LAContext()
  
  private func loadKey() throws {
    var key: CFTypeRef?
    let aatributes: [String: Any] = [
      kSecClass as String: kSecClassKey,
      kSecAttrApplicationTag as String: keyTag,
      kSecAttrKeyType as String: kSecAttrKeyTypeEC,
      kSecUseAuthenticationContext as String: context,
      kSecReturnRef as String: true,
      kSecAttrAccessControl as String: access
    ]
    let status = SecItemCopyMatching(aatributes as CFDictionary, &key)
    
    guard status == errSecSuccess else {
      throw KeyError.unableToLoadKey
    }
    
    let secKey = key as! SecKey
    publicKey = SecKeyCopyPublicKey(secKey)
    privateKey = secKey
  }
  
  func encrypt(plainText: String) throws -> NSData {
    if publicKey == nil {
      getKeys()
    }
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
    if privateKey == nil {
      getKeys()
    }
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
