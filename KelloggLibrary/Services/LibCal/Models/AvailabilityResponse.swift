//
//  AvailabilityResponse.swift
//
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// Represents the response received from the availability API endpoint.
struct AvailabilityResponse: Decodable {

  /// An array of availability slots.
  let slots: [AvailabilitySlot]
}
