//
////
////  NotesViewModel.swift
////  WeatherNotes
////
////  Created by user on 02.09.2025.




//
//import Foundation
//import CoreData
//import SwiftUI
//import CoreLocation
//import Combine
//
//class NotesViewModel: ObservableObject {
//    @Published var notes: [Note] = []
//
//    private let viewContext: NSManagedObjectContext
//    private let locationManager = LocationManager()
//    private let weatherService = WeatherService()
//    private var cancellables = Set<AnyCancellable>()
//
//    init(context: NSManagedObjectContext) {
//        self.viewContext = context
//        fetchNotes()
//    }
//
//    // MARK: - Fetch notes from Core Data
//    func fetchNotes() {
//        let request: NSFetchRequest<Note> = Note.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)]
//        do {
//            notes = try viewContext.fetch(request)
//        } catch {
//            print("Failed to fetch notes: \(error)")
//        }
//    }
//
//    // MARK: - Add note with weather safely
//    func addNoteWithWeather(text: String) {
//        // If location is already available
//        if let coord = locationManager.location {
//            fetchWeatherAndAddNote(text: text, coord: coord)
//        } else {
//            // Wait for first non-nil location update
//            locationManager.$location
//                .compactMap { $0 }
//                .first()
//                .sink { [weak self] coord in
//                    self?.fetchWeatherAndAddNote(text: text, coord: coord)
//                }
//                .store(in: &cancellables)
//        }
//    }
//
//    // MARK: - Fetch weather and create note
//    private func fetchWeatherAndAddNote(text: String, coord: CLLocationCoordinate2D) {
//        weatherService.fetchWeather(lat: coord.latitude, lon: coord.longitude) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let weather):
//                    self?.addNote(
//                        text: text,
//                        temperature: weather.temperature,
//                        weatherIcon: weather.icon,       // already SF Symbol
//                        weatherDesc: weather.description // already user-friendly
//                    )
//                case .failure:
//                    self?.addNote(text: text) // fallback without weather
//                }
//            }
//        }
//    }
//
//    // MARK: - Add note to Core Data
//    func addNote(
//        text: String,
//        temperature: Double = 0,
//        weatherIcon: String = "cloud.sun.fill",
//        weatherDesc: String = "Clear sky"
//    ) {
//        // Prevent duplicates: check if last note is identical
//        if let lastNote = notes.last,
//           lastNote.text == text,
//           lastNote.temperature == temperature,
//           lastNote.weatherIcon == weatherIcon,
//           lastNote.weatherDesc == weatherDesc {
//            return
//        }
//
//        let newNote = Note(context: viewContext)
//        newNote.timestamp = Date()
//        newNote.text = text
//        newNote.temperature = temperature
//        newNote.weatherIcon = weatherIcon
//        newNote.weatherDesc = weatherDesc
//
//        saveContext()
//        fetchNotes()
//    }
//
//    // MARK: - Delete note
//    func delete(note: Note) {
//        viewContext.delete(note)
//        saveContext()
//        fetchNotes()
//    }
//
//    // MARK: - Save Core Data
//    private func saveContext() {
//        do {
//            try viewContext.save()
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//}
//





import Foundation
import CoreData
import SwiftUI
import CoreLocation
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    // For alert
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let viewContext: NSManagedObjectContext
    private let locationManager = LocationManager()
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchNotes()
    }
    
    // MARK: - Fetch notes from Core Data
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)]
        do {
            notes = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }
    
    // MARK: - Add note with weather safely
    func addNoteWithWeather(text: String) {
        if let coord = locationManager.location {
            fetchWeatherAndAddNote(text: text, coord: coord)
        } else {
            locationManager.$location
                .compactMap { $0 }
                .first()
                .sink { [weak self] coord in
                    self?.fetchWeatherAndAddNote(text: text, coord: coord)
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - Fetch weather and create note
    private func fetchWeatherAndAddNote(text: String, coord: CLLocationCoordinate2D) {
        weatherService.fetchWeather(lat: coord.latitude, lon: coord.longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.addNote(
                        text: text,
                        temperature: weather.temperature,
                        weatherIcon: weather.icon,
                        weatherDesc: weather.description
                    )
                case .failure(let error):
                    self?.addNote(text: text) // fallback without weather
                    self?.alertMessage = "Failed to fetch weather: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }
        }
    }
    
    // MARK: - Add note to Core Data
    func addNote(
        text: String,
        temperature: Double = 0,
        weatherIcon: String = "cloud.sun.fill",
        weatherDesc: String = "Clear sky"
    ) {
        if let lastNote = notes.last,
           lastNote.text == text,
           lastNote.temperature == temperature,
           lastNote.weatherIcon == weatherIcon,
           lastNote.weatherDesc == weatherDesc {
            return
        }
        
        let newNote = Note(context: viewContext)
        newNote.timestamp = Date()
        newNote.text = text
        newNote.temperature = temperature
        newNote.weatherIcon = weatherIcon
        newNote.weatherDesc = weatherDesc
        
        saveContext()
        fetchNotes()
    }
    
    // MARK: - Delete note
    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
        fetchNotes()
    }
    
    // MARK: - Save Core Data
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
