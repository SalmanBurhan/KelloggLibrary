//
//  UniversityLibrary.swift
//  KelloggLibrary
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// A class representing a university library.
class UniversityLibrary: ObservableObject {

  /// The unique identifier of the library's location.
  var locationID: Int = 0

  /// The name of the university library.
  var name: String = ""

  /// The base URL of the university library.
  var baseURL: String = ""

  /// An array of floors in the university library.
  var floors = [Floor]()

  /// An array of categories in the university library.
  var categories = [Category]()

  /// An array of capacities in the university library.
  var capacities = [Capacity]()

  /// An array of study rooms in the university library.
  @Published var studyRooms = [StudyRoom]()

  private var capacityDictionary = [Int: Capacity]()
  private var floorDictionary = [Int: Floor]()
  private var categoryDictionary = [Int: Category]()

  /// Initializes a new instance of the `UniversityLibrary` class.
  init(resourceName: String = "KelloggLibrary") {
    loadLibraryData(resourceName)
  }

  private func loadLibraryData(_ resourceName: String) {
    guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
      print("Error loading JSON data.")
      return
    }

    let decoder = JSONDecoder()
    do {
      let libraryData = try decodeLibraryData(from: url, with: decoder)
      locationID = libraryData.id
      name = libraryData.name
      baseURL = libraryData.baseURL
      floors = libraryData.floors
      categories = libraryData.categories
      capacities = libraryData.capacities

      for capacity in capacities {
        capacityDictionary[capacity.id] = capacity
      }

      for floor in floors {
        floorDictionary[floor.id] = floor
      }

      for category in categories {
        categoryDictionary[category.id] = category
      }

      studyRooms = libraryData.rooms.compactMap { room in
        StudyRoom(
          id: room.id,
          name: room.name,
          capacity: capacityDictionary[room.capacityID],
          floor: floorDictionary[room.floorID],
          category: categoryDictionary[room.categoryID]
        )
      }.sorted { $0.floor.level < $1.floor.level }
    } catch {
      print("Error decoding JSON: \(error)")
    }
  }

  private func decodeLibraryData(from url: URL, with decoder: JSONDecoder) throws -> LibraryData {
    let data = try Data(contentsOf: url)
    return try decoder.decode(LibraryData.self, from: data)
  }

  /// Retrieves a study room with the specified ID.
  /// - Parameter id: The ID of the study room.
  /// - Returns: The study room with the specified ID, or `nil` if not found.
  func getRoom(by id: Int) -> StudyRoom? {
    studyRooms.first { $0.id == id }
  }
}
