//
//  Date+Extensions.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// This extension provides additional functionality to `Date`.
extension Date {

  /// Adds a specified number of hours to the date.
  ///
  /// - Parameter hours: The number of hours to add.
  /// - Returns: The new `Date` object after adding the specified number of hours.
  func addingHours(_ hours: Int) -> Date {
    return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
  }

  /// Adds a specified number of days to the date.
  ///
  /// - Parameter days: The number of days to add.
  /// - Returns: The new `Date` object after adding the specified number of days.
  func addingDays(_ days: Int) -> Date {
    return Calendar.current.date(byAdding: .day, value: days, to: self)!
  }

  /// Calculates the time interval (difference) in hours between this date and another date.
  ///
  /// - Parameter date: The other date to compare with.
  /// - Returns: The time interval in hours between the two dates.
  func hours(from date: Date) -> Double {
    return self.timeIntervalSince(date) / 3600  // 3600 seconds in an hour
  }

  /// The date formatted in ISO 8601 format (yyyy-MM-dd).
  var iso8601FormattedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: self)
  }

  /// The time formatted in ISO 8601 format (HH:mm).
  var iso8601FormattedTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: self)
  }

  /// The date formatted in a shorthand format (e.g., "Jan 1st").
  var shorthandDate: String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .ordinal
    numberFormatter.locale = .init(identifier: "en_US")

    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "MMM"

    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "dd"

    let month = monthFormatter.string(from: self)
    let day = dayFormatter.string(from: self)
    let ordinal = numberFormatter.string(from: NSNumber(value: Int(day) ?? 0))

    return "\(month) \(ordinal ?? day)"
  }

  /// The time formatted in the localized time format (e.g., "3:30 PM").
  var localizedTime: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: self)
  }

  /// The date formatted in the localized date format (e.g., "12/31/2022").
  var localizedDate: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter.string(from: self)
  }
}
