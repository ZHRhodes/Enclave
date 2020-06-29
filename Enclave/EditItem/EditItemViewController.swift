//
//  EditItemViewController.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import UIKit

protocol EditItemViewControllerDelegate: class {
  func didFinishEditing(_ note: Note)
}

final class EditItemViewController: UIViewController {
  private let titleTextField = UITextView()
  private let colorButton = ColorPicker()
  private let dateLabel = UILabel()
  private let textView = UITextView()
  
  private var interactor: EditItemInteractor!
  private weak var delegate: EditItemViewControllerDelegate?
  
  private lazy var sideMargin: CGFloat = view.frame.width/16
  
  static func makeInstance(with interactor: EditItemInteractor, delegate: EditItemViewControllerDelegate) -> EditItemViewController {
    let vc = EditItemViewController(nibName: nil, bundle: nil)
    vc.interactor = interactor
    vc.delegate = delegate
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryBackground
    presentationController?.delegate = self
    configureTitleLabel()
    configureDateLabel()
    configureTextField()
    configureColorButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textView.becomeFirstResponder()
  }
  
  private func configureTitleLabel() {
    titleTextField.text = interactor.note.title
    titleTextField.tintColor = .secondaryText
    titleTextField.font = UIFont.customBoldFont(ofSize: 26)
    titleTextField.isScrollEnabled = false
    titleTextField.backgroundColor = .primaryBackground
    titleTextField.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(titleTextField)
    
    let constraints = [
      titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: sideMargin),
      titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin*3),
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureColorButton() {
    colorButton.translatesAutoresizingMaskIntoConstraints = false
    colorButton.selectedColor = interactor.note.color
//    colorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
    
    view.addSubview(colorButton)
    
    let constraints = [
      colorButton.topAnchor.constraint(equalTo: titleTextField.topAnchor, constant: 7),
      colorButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin),
      colorButton.heightAnchor.constraint(equalToConstant: 25),
      colorButton.widthAnchor.constraint(equalToConstant: 25) //will have to remove these height and width constraints
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureDateLabel() {
    dateLabel.text = DateFormatter.monthDayYear.string(from: interactor.note.created)
    dateLabel.font = UIFont.systemFont(ofSize: 16)
    dateLabel.textColor = .secondaryText
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    if let ct = try? SecureEnclave.shared.encrypt(plainText: ".This is a test!") {
      print(try? SecureEnclave.shared.decrypt(cyphertext: ct))
    }
    
    
    view.addSubview(dateLabel)
    
    let constraints = [
      dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 14),
      dateLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor, constant: 5)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureTextField() {
    textView.font = UIFont.systemFont(ofSize: 16)
    textView.tintColor = .secondaryText
    textView.text = interactor.note.content
    textView.backgroundColor = .primaryBackground
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(textView)
    
    let constraints = [
      textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
      textView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
      textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -sideMargin),
      textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  @objc
  private func colorButtonTapped() {
    
  }
}

extension EditItemViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    interactor.note.title = titleTextField.text
    interactor.note.content = textView.text
    interactor.saveNote()
    delegate?.didFinishEditing(interactor.note)
  }
}
