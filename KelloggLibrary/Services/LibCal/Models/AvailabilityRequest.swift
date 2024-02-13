//
//  AvailabilityRequest.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// A struct representing an availability request for a specific location within a certain time range.
///
/// Use this struct to create an availability request for a specific location, start time, and end time.
/// The request can also include pagination parameters such as page index and page size.
struct AvailabilityRequest: Sendable {

  /// The ID of the location for which availability is requested.
  let locationID: Int

  /// The start time of the availability range.
  let start: Date

  /// The end time of the availability range.
  let end: Date

  /// The index of the page to retrieve.
  let pageIndex: Int

  /// The number of items to include per page.
  let pageSize: Int

  /// Initializes an availability request with the given parameters.
  ///
  /// - Parameters:
  ///   - locationID: The ID of the location for which availability is requested.
  ///   - start: The start time of the availability range.
  ///   - end: The end time of the availability range. If not provided, it defaults to the start time plus one day.
  ///   - pageIndex: The index of the page to retrieve. Defaults to 0.
  ///   - pageSize: The number of items to include per page. Defaults to 18.
  init(locationID: Int, start: Date, end: Date? = nil, pageIndex: Int = 0, pageSize: Int = 18) {
    self.locationID = locationID
    self.start = start
    self.end = end ?? start.addingDays(1)
    self.pageIndex = pageIndex
    self.pageSize = pageSize
  }

  /// The HTTP body of the availability request.
  ///
  /// The body parameters are encoded as a dictionary and converted to a URL-encoded string.
  /// The resulting string is then converted to `Data` using UTF-8 encoding.
  ///
  /// - Returns: The HTTP body data of the availability request.
  var httpBody: Data? {
    let bodyParameters: [String: Any] = [
      "lid": locationID,
      "start": start.iso8601FormattedDate,
      "end": end.iso8601FormattedDate,
      "pageIndex": pageIndex,
      "pageSize": pageSize,
    ]
    return
      bodyParameters
      .map { "\($0)=\($1)" }
      .joined(separator: "&")
      .data(using: .utf8)
  }

}
