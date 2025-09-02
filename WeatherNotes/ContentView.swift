//
//  ContentView.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//





import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var viewModel: NotesViewModel
    @State private var showingAddNoteSheet = false
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NotesViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.text ?? "")
                                .font(.headline)
                            if let date = note.timestamp {
                                Text(date, formatter: itemFormatter)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text(note.weatherDesc?.isEmpty == false ? note.weatherDesc! : "Weather description...")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack {
                            Text(note.temperature != 0 ? "\(note.temperature, specifier: "%.1f")°C" : "--°C")
                                .font(.subheadline)
                            Image(systemName: note.weatherIcon?.isEmpty == false ? note.weatherIcon! : "cloud.sun.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.notes[$0] }.forEach(viewModel.delete)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem {
                    Button(action: { showingAddNoteSheet = true }) {
                        Label("Add Note", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNoteSheet) {
                AddNoteSheetView(isPresented: $showingAddNoteSheet) { text in
                    viewModel.addNoteWithWeather(text: text)
                }
            }
            


            
            Text("Select a note")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
}
