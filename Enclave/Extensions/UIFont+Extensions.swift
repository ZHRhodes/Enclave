//
//  UIFont+Extensions.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/18/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import UIKit

extension UIFont {
  static func customBoldFont(ofSize size: CGFloat) -> UIFont {
    return UIFont.init(name: "HelveticaNeue-Bold", size: size)!
  }
  
  static func customRegularFont(ofSize size: CGFloat) -> UIFont {
    return UIFont.init(name: "HelveticaNeue", size: size)!
  }
  
  static func customItalicFont(ofSize size: CGFloat) -> UIFont {
    return UIFont.init(name: "HelveticaNeue-Italic", size: size)!
  }
}
