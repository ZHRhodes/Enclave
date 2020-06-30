//
//  ListItemTableCell.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation
import UIKit

final class ListItemTableCell: UITableViewCell {
  static let height: CGFloat = 80
  static let id = "ListItemTableCellId"
  
  private let containerView = UIView()
  private let stack = UIStackView()
  private let titleLabel = UILabel()
  private let dateLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureLayout()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if #available(iOS 13.0, *) {
      if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
        updateLayer(for: traitCollection.userInterfaceStyle)
      }
    }
  }
  
  func configure(with note: Note) {
    titleLabel.text = note.title
    dateLabel.text = DateFormatter.shorthandMonthDayYearTime.string(from: note.lastModified)
    containerView.backgroundColor = note.color
  }
  
  private func configureLayout() {
    selectionStyle = .none
    backgroundColor = .primaryBackground
    configureContainerView()
    configureStackView()
    configureTitleLabel()
    configureDateLabel()
    updateLayer(for: traitCollection.userInterfaceStyle)
  }
  
  private func configureContainerView() {
    containerView.layer.cornerRadius = 4
    containerView.translatesAutoresizingMaskIntoConstraints = false
//    containerView.backgroundColor = .white
    
    contentView.addSubview(containerView)
    
    let constraints = [
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureStackView() {
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 0
    
    containerView.addSubview(stack)
    
    let constraints = [
      stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
      stack.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
      stack.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16),
      stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
    ]
    
    NSLayoutConstraint.activate(constraints)
  }
  
  private func configureTitleLabel() {
    titleLabel.font = .customRegularFont(ofSize: 17)
    titleLabel.textColor = .primaryText
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    stack.addArrangedSubview(titleLabel)
  }
  
  private func configureDateLabel() {
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.textColor = .secondaryText
    dateLabel.font = .customItalicFont(ofSize: 13)
    
    stack.addArrangedSubview(dateLabel)
  }
  
  private func updateLayer(for style: UIUserInterfaceStyle) {
    if style == .light {
      containerView.clipsToBounds = false
      containerView.layer.shadowColor = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 0.8).cgColor
      containerView.layer.shadowOpacity = 1.0
      containerView.layer.shadowRadius = 3.0
      containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    } else {
      containerView.layer.shadowOpacity = 0.0
    }
  }
}
