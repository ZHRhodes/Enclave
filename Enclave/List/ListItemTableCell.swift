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
  
  func configure(with note: Note) {
    titleLabel.text = note.title
    dateLabel.text = DateFormatter.shorthandMonthDayYear.string(from: note.created)
    containerView.backgroundColor = note.color
  }
  
  private func configureLayout() {
    selectionStyle = .none
    backgroundColor = .primaryBackground
    configureContainerView()
    configureStackView()
    configureTitleLabel()
    configureDateLabel()
  }
  
  private func configureContainerView() {
    containerView.layer.cornerRadius = 4
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
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
    titleLabel.textColor = .primaryText
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    stack.addArrangedSubview(titleLabel)
  }
  
  private func configureDateLabel() {
    dateLabel.translatesAutoresizingMaskIntoConstraints = false
    dateLabel.textColor = .secondaryText
    dateLabel.font = UIFont.italicSystemFont(ofSize: 14)
    
    stack.addArrangedSubview(dateLabel)
  }
}
