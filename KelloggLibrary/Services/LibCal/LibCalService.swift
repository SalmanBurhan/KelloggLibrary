//
//  LibCalService.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// A service class for interacting with the LibCal API.
class LibCalService: ObservableObject {

  /// The university library associated with the service.
  let library: UniversityLibrary

  /// The base URL of the LibCal API.
  let baseURL: URL?

  /// The location ID of the library.
  let locationID: Int

  /// The available slots for booking.
  @Published var availableSlots = [AvailableSlot]()

  /// Initializes a new instance of `LibCalService`.
  /// - Parameter library: The university library to associate with the service.
  init(for library: UniversityLibrary) {
    self.library = library
    self.baseURL = URL(string: library.baseURL)
    self.locationID = library.locationID
  }

  /// The JSON decoder used for decoding API responses.
  var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()

  /// Updates the availability of slots based on the provided request.
  /// - Parameter request: The availability request.
  /// - Throws: An error if the update fails.
  func updateAvailability(with request: AvailabilityRequest) async throws {
    guard let baseURL else { throw URLError(.badURL) }
    let url = LibCalEndpoint.availability(baseURL).url

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue(
      "application/x-www-form-urlencoded; charset=UTF-8",
      forHTTPHeaderField: "Content-Type")
    urlRequest.addValue(
      baseURL.absoluteString,
      forHTTPHeaderField: "Referer")
    urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData  // TODO: - CHANGE CACHE POLICY
    urlRequest.httpBody = request.httpBody
    let (data, _) = try await URLSession.shared.data(for: urlRequest)
    let response = try jsonDecoder.decode(AvailabilityResponse.self, from: data)
    let slots = response.slots
    let availableSlots =
      slots
      .filter { $0.isAvailable }
      .compactMap {
        AvailableSlot(
          room: library.getRoom(by: $0.roomID),
          start: $0.start,
          end: $0.end,
          checksum: $0.checksum
        )
      }
      .sorted { $0.room.name < $1.room.name }
    DispatchQueue.main.async {
      self.availableSlots = availableSlots
    }
  }

  /// Filters the available slots based on the specified window of time.
  ///
  /// - Parameters:
  ///   - windowStart: The start date of the time window.
  ///   - windowEnd: The end date of the time window.
  /// - Returns: An array of `AvailableSlot` objects that fall within the specified window.
  func filterSlots(windowStart: Date, windowEnd: Date) -> [AvailableSlot] {
    // Filter slots that at least start within the given time window
    let relevantSlots = self.availableSlots.filter {
      $0.start >= windowStart && $0.start < windowEnd
    }

    // Group slots by roomID
    let groupedSlots = Dictionary(grouping: relevantSlots) { $0.room.id }

    // Filter out groups that do not cover the entire window with consecutive slots
    let validSlots = groupedSlots.compactMapValues { (slots: [AvailableSlot]) -> [AvailableSlot]? in
      // Ensure slots are sorted by start time
      let sortedSlots = slots.sorted { $0.start < $1.start }

      // Check for consecutive availability in 30-minute intervals
      var currentStart = windowStart
      var consecutiveSlots = [AvailableSlot]()

      for slot in sortedSlots {
        if slot.start == currentStart && slot.end == currentStart.addingTimeInterval(1800) {  // 1800 seconds = 30 minutes
          consecutiveSlots.append(slot)
          currentStart = slot.end  // Move to the next interval
        }

        if currentStart >= windowEnd {
          return consecutiveSlots  // Found consecutive slots covering the window
        }
      }

      return nil  // Did not cover the entire window with consecutive slots
    }

    // Flatten the result and return only the slots
    return Array(validSlots.values.joined())
  }

}
