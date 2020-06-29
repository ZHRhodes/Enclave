//
//  Note.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/17/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import UIKit
import CoreData

struct Note {
  let id: String
  var title: String
  var color: UIColor
  let created: Date
  let lastModified: Date
  var content: String
  var cyphertext: NSData
  
  var plaintext: String {
    get {
      do {
        return try SecureEnclave.shared.decrypt(cyphertext: cyphertext)
      } catch {
        return ""
      }
    }
    set {
      do  {
        cyphertext = try SecureEnclave.shared.encrypt(plainText: newValue)
      } catch {
        return
      }
    }
  }
  
  init(title: String, color: UIColor, created: Date, lastModified: Date, content: String, cyphertext: NSData) {
    self.id = UUID().uuidString
    self.title = title
    self.color = color
    self.created = created
    self.lastModified = lastModified
    self.content = content
    self.cyphertext = cyphertext
  }
  
  init() {
    self.init(title: "Title", color: UIColor.randomAccent(), created: Date(), lastModified: Date(), content: "", cyphertext: NSData())
  }
  
  init(managedObject: NSManagedObject) {
    self.id = managedObject.value(forKey: "id") as? String ?? UUID().uuidString
    self.title = managedObject.value(forKey: "title") as? String ?? ""
    let hex = managedObject.value(forKey: "color") as? String ?? "000000"
    self.color = UIColor(hex: hex)
    self.created = managedObject.value(forKey: "created") as? Date ?? Date()
    self.lastModified = managedObject.value(forKey: "lastModified") as? Date ?? Date()
    self.content = managedObject.value(forKey: "content") as? String ?? ""
    self.cyphertext = managedObject.value(forKey: "cyphertext") as? NSData ?? NSData()
  }
  
  func setProperties(in managedObject: NSManagedObject) {
    managedObject.setValue(id, forKey: "id")
    managedObject.setValue(title, forKey: "title")
    managedObject.setValue(color.toHex(), forKey: "color")
    managedObject.setValue(created, forKey: "created")
    managedObject.setValue(lastModified, forKey: "lastModified")
    managedObject.setValue(content, forKey: "content")
    managedObject.setValue(cyphertext, forKey: "cyphertext")
  }
}
