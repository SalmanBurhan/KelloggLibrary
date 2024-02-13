//
//  Int+Extensions.swift
//  KelloggLibrary
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// This extension provides additional functionality to `Int`.
extension Int {
  /// Returns the ordinal representation of the integer.
  ///
  /// For example, 1 becomes "1st", 2 becomes "2nd", 3 becomes "3rd", and so on.
  ///
  /// - Returns: The ordinal representation of the integer.
  var ordinal: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .ordinal
    let number = NSNumber(integerLiteral: self)
    return formatter.string(from: number) ?? "\(self)"
  }
}
