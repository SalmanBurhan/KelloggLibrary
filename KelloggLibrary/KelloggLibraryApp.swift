//
//  KelloggLibraryApp.swift
//  KelloggLibrary
//
//  Created by Salman Burhan on 2/13/24.
//

import SwiftUI

@main
struct KelloggLibraryApp: App {

  /// The library object that will be used throughout the app
  let library: UniversityLibrary
  /// The LibCalService object that will be used throughout the app
  let libCalService: LibCalService

  init() {
    library = UniversityLibrary()
    libCalService = LibCalService(for: library)
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(library)
        .environmentObject(libCalService)
    }
  }
}
