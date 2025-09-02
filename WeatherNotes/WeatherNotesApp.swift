//
//  WeatherNotesApp.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//

import SwiftUI

@main
struct WeatherNotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
