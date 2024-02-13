//
//  LibCalEndpoint.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// Represents the available endpoints for the LibCal service.
enum LibCalEndpoint {
  /// The availability endpoint.
  case availability(_ baseURL: URL)

  /// The path for the endpoint.
  var path: String {
    switch self {
    case .availability:
      return "/spaces/availability/grid"
    }
  }

  /// The URL for the endpoint.
  var url: URL {
    switch self {
    case .availability(let baseURL):
      return baseURL.appending(path: path)
    }
  }
}
