
//
//  Persistence.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Generate sample notes for SwiftUI Preview
        for i in 1...10 {
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date()
            newNote.text = "Preview note #\(i)"
            newNote.temperature = Double(Int.random(in: -5...30))
            newNote.weatherIcon = "sun.max.fill"
            newNote.weatherDesc = "Clear sky"
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved Core Data error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WeatherNotes")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}


