//
//  ContentView.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//



import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch all notes from Core Data, sorted by creation date
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: true)],
        animation: .default)
    private var notes: FetchedResults<Note>

    var body: some View {
        NavigationView {
            List {
                ForEach(notes) { note in
                    HStack {
                        // Left side: text and metadata
                        VStack(alignment: .leading) {
                            // Note text
                            Text(note.text ?? "")
                                .font(.headline)
                            
                            // Creation date
                            if let date = note.timestamp {
                                Text(date, formatter: itemFormatter)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Weather description (placeholder if empty)
                            Text(note.weatherDesc?.isEmpty == false ? note.weatherDesc! : "Weather description...")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // Right side: weather data
                        VStack {
                            // Temperature (placeholder if 0)
                            Text(note.temperature != 0 ? "\(note.temperature, specifier: "%.1f")°C" : "--°C")
                                .font(.subheadline)
                            
                            // Weather icon (placeholder if empty)
                            Image(systemName: note.weatherIcon?.isEmpty == false ? note.weatherIcon! : "cloud.sun.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .toolbar {
                // Edit mode button
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                // Add note button
                ToolbarItem {
                    Button(action: addNote) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
            
            // Default text if no note is selected (on iPad / Mac)
            Text("Select a note")
        }
    }

    // Create and save a new note
    private func addNote() {
        withAnimation {
            let newNote = Note(context: viewContext)
            newNote.timestamp = Date()
            newNote.text = "New note"
            newNote.temperature = 0
            newNote.weatherIcon = "" // Placeholder will be used
            newNote.weatherDesc = "" // Placeholder will be used

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved Core Data error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Delete selected notes
    private func deleteNotes(offsets: IndexSet) {
        withAnimation {
            offsets.map { notes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved Core Data error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// Date formatter for displaying note timestamps
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
