//
//  ListViewInteractor.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/20/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct ListViewInteractor {
  @NewestFirst var notes: [Note] = []
  
  init() {
    fetchNotes()
  }
  
  mutating private func fetchNotes() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NoteEntity")
    
    do {
      notes = try managedContext.fetch(fetchRequest).map(Note.init)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
}
