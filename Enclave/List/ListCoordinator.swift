//
//  ListCoordinator.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import UIKit

final class ListCoordinator {
  weak var viewController: ListViewController?
  
  private var editItemCoordinator: EditItemCoordinator?
  
  init(viewController: ListViewController?) {
    self.viewController = viewController
  }
  
  func presentEditItem(with note: Note) {
    guard let viewController = viewController else { return }
    editItemCoordinator = EditItemCoordinator()
    editItemCoordinator?.delegate = self
    editItemCoordinator?.present(with: note, parent: viewController)
  }
}

extension ListCoordinator: EditItemCoordinatorDelegate {
  func didFinishEditingNote(_ note: Note) {
    viewController?.updatedNote(note)
  }
}
