//
//  EditItemCoordinator.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import UIKit

protocol EditItemCoordinatorDelegate: class {
  func didFinishEditingNote(_ note: Note)
}

final class EditItemCoordinator {
  private weak var parentViewController: UIViewController?
  private var viewController: UIViewController?
  weak var delegate: EditItemCoordinatorDelegate?
  
  func present(with note: Note, parent: UIViewController) {
    let interactor = EditItemInteractor(note: note)
    let vc = EditItemViewController.makeInstance(with: interactor, delegate: self)
    viewController = vc
    parentViewController = parent
    parent.present(vc, animated: true, completion: nil)
  }
}

extension EditItemCoordinator: EditItemViewControllerDelegate {
  func didFinishEditing(_ note: Note?) {
      if let note = note {
        self.delegate?.didFinishEditingNote(note)
      }
  }
}
