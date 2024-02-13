//
//  KelloggLibraryApp.swift
//  KelloggLibrary
//
//  Created by Salman Burhan on 2/13/24.
//

import SwiftUI

@main
struct KelloggLibraryApp: App {

  /// The library object that will be shared across the app
  let library: UniversityLibrary

  init() {
    library = UniversityLibrary()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(library)
    }
  }
}
