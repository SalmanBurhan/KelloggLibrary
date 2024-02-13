//
//  Array+Extensions.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// This extension provides additional functionality to `Array`.
extension Array where Element: Hashable {

  /// Returns an array containing only the unique elements of the original array.
  ///
  /// - Returns: An array with unique elements.
  func unique() -> [Element] {
    var set = Set<Element>()
    return filter { set.insert($0).inserted }
  }
}
