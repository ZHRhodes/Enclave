//
//  ColorPicker.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/20/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
  func selectedColor(_ color: UIColor)
}

class ColorPicker: UIView {
  private let selectedColorView = UIView()
  private let backgroundContainer = UIView()
  
  var selectedColor = UIColor() {
    didSet {
      selectedColorView.backgroundColor = selectedColor
    }
  }
  var colors: [UIColor] = UIColor.accents
  var colorButtons: [UIButton] = []
  weak var delegate: ColorPickerDelegate?
  
  private let boxSize: CGFloat = 30.0
  private lazy var padding: CGFloat = boxSize/2
  
  init() {
    super.init(frame: .zero)
    configure()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    for subview in subviews as [UIView] {
      if !subview.isHidden
        && subview.alpha > 0
        && subview.isUserInteractionEnabled
        && subview.point(inside: convert(point, to: subview), with: event) {
          return true
      }
    }
    return false
  }
  
  private func configure() {
    isUserInteractionEnabled = true
    selectedColorView.isUserInteractionEnabled = true
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedColorTapped))
    selectedColorView.addGestureRecognizer(tapRecognizer)
    selectedColorView.layer.cornerRadius = 4
    selectedColorView.translatesAutoresizingMaskIntoConstraints = true
    addSubview(selectedColorView)
    selectedColorView.frame = CGRect(x: 0, y: 0, width: boxSize, height: boxSize)
    
    backgroundContainer.translatesAutoresizingMaskIntoConstraints = true
    backgroundContainer.backgroundColor = .colorPickerBackground
    backgroundContainer.layer.cornerRadius = 6
    backgroundContainer.frame = selectedColorView.frame
    insertSubview(backgroundContainer, at: 0)
  }
  
  private func makeColorButton(with color: UIColor) -> UIButton {
    let button = UIButton()
    button.backgroundColor = color
    button.layer.cornerRadius = 4
    button.addTarget(self, action: #selector(newColorTapped), for: .touchUpInside)
    if color.toHex() == selectedColor.toHex() {
      button.layer.borderWidth = 2.0
      button.layer.borderColor = UIColor.white.cgColor
    }
    return button
  }
  
  private func addColorButtons() {
    var pt = CGPoint(x: backgroundContainer.frame.minX + padding, y: backgroundContainer.frame.minY + padding)
    var idx = colors.startIndex
    
    while backgroundContainer.frame.contains(CGPoint(x: pt.x, y: pt.y)) {
      while backgroundContainer.frame.contains(CGPoint(x: pt.x, y: pt.y)) {
        let button = makeColorButton(with: colors[idx])
        button.frame = CGRect(x: pt.x, y: pt.y, width: boxSize, height: boxSize)
        addSubview(button)
        colorButtons.append(button)
        pt.x += boxSize + padding
        idx = idx.advanced(by: 1)
      }
      pt.x = backgroundContainer.frame.minX + padding
      pt.y += boxSize + padding
    }
  }
  
  @objc
  private func selectedColorTapped() {
    let numberOfColumns = ceil(CGFloat(self.colors.count)/2.0)
    UIView.animate(withDuration: 0.15, animations: {
      self.backgroundContainer.frame = self.selectedColorView.frame
        .applying(CGAffineTransform(scaleX: 2.5 + (numberOfColumns-1), y: 3.5))
        .applying(CGAffineTransform(translationX: (-(self.boxSize + self.padding*2) * (numberOfColumns-1)), y: -self.padding))
    }, completion: { _ in
      UIView.animate(withDuration: 0.1, animations: {
        self.addColorButtons()
      })
    })
  }
  
  @objc
  private func newColorTapped(sender: UIButton) {
    UIView.animate(withDuration: 0.18) {
      self.colorButtons.forEach { $0.removeFromSuperview() }
      self.backgroundContainer.frame = self.selectedColorView.frame
    }
    colorButtons = []
    if let backgroundColor = sender.backgroundColor {
      selectedColor = backgroundColor
      delegate?.selectedColor(backgroundColor)
    }
  }
}
