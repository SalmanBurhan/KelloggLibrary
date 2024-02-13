//
//  LibraryData.swift
//  KelloggLibrary
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// Represents the data structure for the library information.
struct LibraryData: Identifiable, Codable {
  var id: Int
  var baseURL: String
  var name: String
  var floors: [Floor]
  var categories: [Category]
  var capacities: [Capacity]
  internal var rooms: [Room]
}

/// Represents the capacity information for a room.
struct Capacity: Identifiable, Codable {
  var id: Int
  var minimum: Int
  var maximum: Int
}

/// Represents the category information for a room.
struct Category: Identifiable, Codable {
  var id: Int
  var name: String
}

/// Represents the floor information for a room.
struct Floor: Identifiable, Codable {
  var id: Int
  var level: Int
}

/// Represents the room information.
internal struct Room: Identifiable, Codable {
  var id: Int
  var name: String
  var floorID: Int
  var categoryID: Int
  var capacityID: Int
}

/// Represents a study room in the library.
struct StudyRoom: Identifiable {
  var id: Int
  var name: String
  var capacity: Capacity
  var floor: Floor
  var category: Category

  /// Initializes a study room with the given parameters.
  /// - Parameters:
  ///   - id: The ID of the study room.
  ///   - name: The name of the study room.
  ///   - capacity: The capacity of the study room.
  ///   - floor: The floor where the study room is located.
  ///   - category: The category of the study room.
  init?(id: Int, name: String, capacity: Capacity?, floor: Floor?, category: Category?) {
    guard let capacity = capacity, let floor = floor, let category = category else { return nil }
    self.id = id
    self.name = name
    self.capacity = capacity
    self.floor = floor
    self.category = category
  }
}
