//
//  AvailableSlot.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// A struct representing an available slot for a study room.
///
/// An `AvailableSlot` object contains information about the study room, start and end times of the slot, and a checksum value.
/// It conforms to the `Identifiable` and `Equatable` protocols.
struct AvailableSlot: Identifiable, Equatable {

  /// The unique identifier of the available slot.
  var id: String { checksum }

  /// The study room associated with the available slot.
  let room: StudyRoom

  /// The start time of the available slot.
  let start: Date

  /// The end time of the available slot.
  let end: Date

  /// The checksum value of the available slot.
  let checksum: String

  /// Initializes an `AvailableSlot` object.
  ///
  /// - Parameters:
  ///   - room: The study room associated with the available slot.
  ///   - start: The start time of the available slot.
  ///   - end: The end time of the available slot.
  ///   - checksum: The checksum value of the available slot.
  /// - Returns: An initialized `AvailableSlot` object, or `nil` if the `room` parameter is `nil`.
  init?(room: StudyRoom?, start: Date, end: Date, checksum: String) {
    guard let room else { return nil }
    self.room = room
    self.start = start
    self.end = end
    self.checksum = checksum
  }

  /// Checks if two `AvailableSlot` objects are equal.
  ///
  /// - Parameters:
  ///   - lhs: The left-hand side `AvailableSlot` object.
  ///   - rhs: The right-hand side `AvailableSlot` object.
  /// - Returns: `true` if the checksum values of the two objects are equal, otherwise `false`.
  static func == (lhs: AvailableSlot, rhs: AvailableSlot) -> Bool {
    return lhs.checksum == rhs.checksum
  }
}
