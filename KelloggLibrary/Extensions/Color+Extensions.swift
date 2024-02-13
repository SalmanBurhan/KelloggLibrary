//
//  Color+Extensions.swift
//  KellogLibrary
//
//  Created by Salman Burhan on 2/4/24.
//

import SwiftUI

/// This extension provides additional color options to `UIColor`.
extension UIColor {
  /// University Blue color with RGB values (0, 42, 89) and alpha 1.
  static let universityBlue = UIColor(red: 0 / 255.0, green: 42 / 255.0, blue: 89 / 255.0, alpha: 1)

  /// Cougar Blue color with RGB values (0, 96, 252) and alpha 1.
  static let cougarBlue = UIColor(red: 0 / 255.0, green: 96 / 255.0, blue: 252 / 255.0, alpha: 1)

  /// Spirit Blue color with RGB values (58, 181, 232) and alpha 1.
  static let spiritBlue = UIColor(red: 58 / 255.0, green: 181 / 255.0, blue: 232 / 255.0, alpha: 1)
}

/// This extension provides additional color options to `Color`.
extension Color {
  /// University Blue color.
  static let universityBlue = Color(.universityBlue)

  /// Cougar Blue color.
  static let cougarBlue = Color(.cougarBlue)

  /// Spirit Blue color.
  static let spiritBlue = Color(.spiritBlue)
}
