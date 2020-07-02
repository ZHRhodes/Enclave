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
  func didFinishEditing(_ note: Note?)
}

final class EditItemViewController: UIViewController {
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let titleTextField = UITextView()
  private let colorPicker = ColorPicker()
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
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustInsetForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustInsetForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    configureScrollView()
    configureContentView()
    configureTitleLabel()
    configureDateLabel()
    configureTextView()
    configureColorButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if textView.text.isEmpty {
      textView.becomeFirstResponder()
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
        updateLayer(for: traitCollection.userInterfaceStyle)
      }
    }
  }
  
  private func configureScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
    view.addSubview(scrollView)
    
    let constraints = [
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)
    
    let constraints = [
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
      contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureTitleLabel() {
    titleTextField.text = interactor.note.title
    titleTextField.tintColor = .secondaryText
    titleTextField.font = UIFont.customBoldFont(ofSize: 26)
    titleTextField.isScrollEnabled = false
    titleTextField.backgroundColor = .primaryBackground
    titleTextField.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(titleTextField)
    
    let constraints = [
      titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: sideMargin),
      titleTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideMargin*3),
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureColorButton() {
    colorPicker.translatesAutoresizingMaskIntoConstraints = false
    colorPicker.selectedColor = interactor.note.color
    colorPicker.delegate = self
    updateLayer(for: traitCollection.userInterfaceStyle)
    
    contentView.addSubview(colorPicker)
    
    let constraints = [
      colorPicker.topAnchor.constraint(equalTo: titleTextField.topAnchor, constant: 7),
      colorPicker.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideMargin),
      colorPicker.heightAnchor.constraint(equalToConstant: 25),
      colorPicker.widthAnchor.constraint(equalToConstant: 25)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureDateLabel() {
    dateLabel.text = DateFormatter.monthDayYear.string(from: interactor.note.created)
    dateLabel.font = UIFont.customRegularFont(ofSize: 16)
    dateLabel.textColor = .secondaryText
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(dateLabel)
    
    let constraints = [
      dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 14),
      dateLabel.leftAnchor.constraint(equalTo: titleTextField.leftAnchor, constant: 5)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureTextView() {
    textView.font = .customRegularFont(ofSize: 16)
    textView.tintColor = .secondaryText
    textView.text = interactor.note.plaintext
    textView.backgroundColor = .primaryBackground
    textView.isScrollEnabled = false
    textView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(textView)
    
    let constraints = [
      textView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
      textView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
      textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -sideMargin),
      textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 600)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func updateLayer(for style: UIUserInterfaceStyle) {
    if style == .light {
      colorPicker.clipsToBounds = false
      colorPicker.layer.shadowColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.8).cgColor
      colorPicker.layer.shadowOpacity = 1.0
      colorPicker.layer.shadowRadius = 2.0
      colorPicker.layer.shadowOffset = CGSize(width: 0, height: 2)
    } else {
      colorPicker.layer.shadowOpacity = 0.0
    }
  }
  
  @objc private func adjustInsetForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

    if notification.name == UIResponder.keyboardWillHideNotification {
        scrollView.contentInset = .zero
    } else {
        scrollView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }

    scrollView.scrollIndicatorInsets = scrollView.contentInset
  }
}

extension EditItemViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    interactor.note.title = titleTextField.text
    interactor.note.plaintext = textView.text
    if interactor.note.hasBeenModified {
      interactor.saveNote()
      delegate?.didFinishEditing(interactor.note)
    } else {
      delegate?.didFinishEditing(nil)
    }
  }
}

extension EditItemViewController: ColorPickerDelegate {
  func selectedColor(_ color: UIColor) {
    interactor.note.color = color
  }
}
