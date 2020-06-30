//
//  EditItemInteractor.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct EditItemInteractor {
  var note: Note
  
  mutating func saveNote() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
    fetchRequest.predicate = NSPredicate(format: "id == %@", note.id)

    do {
      guard let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
      note.lastModified = Date()
      if results.count != 0 {
        let managedNote = results[0]
        note.setProperties(in: managedNote)
      } else {
        let entity = NSEntityDescription.entity(forEntityName: "NoteEntity", in: managedContext)!
        let managedNote = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setProperties(in: managedNote)
      }
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }
}
