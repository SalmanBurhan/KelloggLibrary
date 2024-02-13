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
}
