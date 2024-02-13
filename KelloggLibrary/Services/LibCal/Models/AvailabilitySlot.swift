//
//  AvailabilitySlot.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// A struct representing an availability slot for a room in the library.
struct AvailabilitySlot: Decodable, Identifiable {

  /// The unique identifier for the availability slot.
  var id: String { checksum }

  /// The ID of the room.
  let roomID: Int

  /// The start date and time of the availability slot.
  let start: Date

  /// The end date and time of the availability slot.
  let end: Date

  /// The checksum value for the availability slot.
  let checksum: String

  /// A flag indicating whether the availability slot is available or not.
  let isAvailable: Bool

  enum CodingKeys: String, CodingKey {
    case roomID = "itemId"
    case start
    case end
    case checksum
    case className
  }

  /// Initializes an availability slot from a decoder.
  /// - Parameter decoder: The decoder to use for decoding the availability slot.
  /// - Throws: An error if the decoding fails.
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.roomID = try container.decode(Int.self, forKey: .roomID)
    self.start = try container.decode(Date.self, forKey: .start)
    self.end = try container.decode(Date.self, forKey: .end)
    self.checksum = try container.decode(String.self, forKey: .checksum)
    self.isAvailable = try container.decodeIfPresent(String.self, forKey: .className) == nil
  }
}
