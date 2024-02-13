//
//  ReservationBuilder.swift
//  KelloggLibrary
//
//  Created by Salman Burhan on 2/13/24.
//

import Foundation

/// A class responsible for building reservation requests.
class ReservationRequestBuilder: ObservableObject {

  /// The `LibCalService` used for retrieving available slots.
  private var libCalService: LibCalService

  /// The range of available dates for the reservation.
  @Published var availableDates: ClosedRange<Date>

  /// The available start times for the reservation.
  @Published var availableStartTimes = [Date]()

  /// The available end times for the reservation.
  @Published var availableEndTimes = [Date]()

  /// The selected date for the reservation.
  @Published var date: Date {
    didSet {
      print("Did Set Reservation Request Date To \(date.iso8601FormattedDate)")
      self.updateStartTimes()
    }
  }

  /// The selected start time for the reservation.
  @Published var startTime: Date? {
    didSet {
      print("Did Set Reservation Request START Time To \(startTime?.iso8601FormattedTime ?? "nil")")
      self.updateEndTimes()
    }
  }

  /// The selected end time for the reservation.
  @Published var endTime: Date? {
    didSet {
      print("Did Set Reservation Request END Time To \(endTime?.iso8601FormattedTime ?? "nil")")
    }
  }

  /// The ID of the room for the reservation.
  @Published var roomID: String?

  /// The checksum for the reservation.
  @Published var checksum: String?

  /// Initializes a new instance of `ReservationRequestBuilder`.
  /// - Parameter service: The `LibCalService` used for retrieving available slots.
  init(service: LibCalService) {
    let today = Date.now
    let calendar = Calendar.current
    let startComponents = calendar.dateComponents([.year, .month, .day], from: today)
    let endComponents = calendar.dateComponents([.year, .month, .day], from: today.addingDays(14))
    self.availableDates =
      calendar.date(from: startComponents)!...calendar.date(from: endComponents)!
    self.date = today
    self.libCalService = service
  }

  /// Resets the available start times to an empty array.
  func resetStartTimes() {
    DispatchQueue.main.async {
      self.availableStartTimes = []
    }
  }

  /// Resets the available end times to an empty array.
  func resetEndTimes() {
    DispatchQueue.main.async {
      self.availableEndTimes = []
    }
  }

  /// Updates the available start times based on the selected date.
  func updateStartTimes() {
    self.resetStartTimes()
    self.resetEndTimes()
    let newStartTimes = libCalService
      .availableSlots
      .map { $0.start }
      .sorted()
      .unique()
    DispatchQueue.main.async {
      self.availableStartTimes = newStartTimes
    }
  }

  /// Updates the available end times based on the selected start time.
  func updateEndTimes() {
    guard let startTime else {
      self.resetEndTimes()
      return
    }
    self.resetEndTimes()
    let largestTimeInterval = startTime.addingHours(3)
    let newEndTimes = libCalService
      .availableSlots
      .filter { $0.start > startTime && $0.end <= largestTimeInterval }
      .map { $0.end }
    DispatchQueue.main.async {
      self.availableEndTimes = newEndTimes
    }
  }
}
