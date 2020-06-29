//
//  UIColor+Extensions.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import UIKit

extension UIColor {
  static let primaryBackground = UIColor(named: "primaryBackground")!
  static let titleText = UIColor(named: "titleText")!
  static let secondaryText = UIColor(named: "secondaryText")!
  static let primaryText = UIColor(named: "primaryText")!
  static let accentOne = UIColor(named: "accentOne")!
  static let accentTwo = UIColor(named: "accentTwo")!
  static let accentThree = UIColor(named: "accentThree")!
  static let accentFour = UIColor(named: "accentFour")!
  static let accentFive = UIColor(named: "accentFive")!
  
  static let accents: [UIColor] = [.accentTwo, .accentThree, .accentFour, .accentFive]
  
  static func randomAccent() -> UIColor {
    return accents.randomElement()!
  }
  
  convenience init(hex: String) {
    var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (hex.hasPrefix("#")) {
      hex = String(hex.dropFirst())
    }
    
    if (hex.count != 6) {
      self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
      return
    }

    var rgbValue: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&rgbValue)

    self.init(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  func toHex() -> String {
      guard let components = cgColor.components, components.count >= 3 else {
          return "000000"
      }

      let r = Float(components[0])
      let g = Float(components[1])
      let b = Float(components[2])

      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
  }
}
