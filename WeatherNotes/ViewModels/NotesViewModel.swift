
//
//  NotesViewModel.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//


import Foundation
import CoreData
import SwiftUI
import CoreLocation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    private let viewContext: NSManagedObjectContext
    private let locationManager = LocationManager()
    private let weatherService = WeatherService()
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchNotes()
    }
    
    // Fetch all notes from Core Data
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)]
        
        do {
            notes = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }
    
    // Map OpenWeather icon codes to SF Symbols
    private func sfSymbol(for weatherIcon: String) -> String {
        switch weatherIcon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.heavyrain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.sun.fill"
        }
    }
    
    // Add note with custom text, fetches weather if location available
    func addNoteWithWeather(text: String) {
        guard let coord = locationManager.location else {
            addNote(text: text)
            return
        }
        
        weatherService.fetchWeather(lat: coord.latitude, lon: coord.longitude) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let temp = data.main.temp
                    let iconCode = data.weather.first?.icon ?? "01d"
                    let icon = self.sfSymbol(for: iconCode)
                    let desc = data.weather.first?.description ?? "Clear sky"
                    self.addNote(text: text, temperature: temp, weatherIcon: icon, weatherDesc: desc)
                case .failure(let error):
                    print("Weather fetch failed: \(error.localizedDescription)")
                    self.addNote(text: text)
                }
            }
        }
    }
    
    // Add note with optional weather parameters
    func addNote(text: String, temperature: Double = 0, weatherIcon: String = "", weatherDesc: String = "") {
        let newNote = Note(context: viewContext)
        newNote.timestamp = Date()
        newNote.text = text
        newNote.temperature = temperature
        newNote.weatherIcon = weatherIcon
        newNote.weatherDesc = weatherDesc
        
        saveContext()
        fetchNotes()
    }
    
    // Delete note
    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
        fetchNotes()
    }
    
    // Save Core Data context
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
