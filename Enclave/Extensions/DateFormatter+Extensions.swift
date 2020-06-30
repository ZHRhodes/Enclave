//
//  DateFormatter+Extensions.swift
//  Enclave
//
//  Created by Zachary Rhodes on 6/20/20.
//  Copyright © 2020 zhrhodes. All rights reserved.
//

import Foundation

extension DateFormatter {
  static let monthDayYear: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    return formatter
  }()
  
  static let shorthandMonthDayYearTime: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d/yy h:mma"
    return formatter
  }()
}
