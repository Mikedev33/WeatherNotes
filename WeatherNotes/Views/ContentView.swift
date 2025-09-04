//
//  ContentView.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//




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
                    NavigationLink(destination: NoteDetailView(note: note)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.text ?? "")
                                    .font(.headline)
                                
                                if let date = note.timestamp {
                                    Text(date, formatter: Formatters.noteDate)
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
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.notes[$0] }.forEach(viewModel.delete)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Text("Select a note")
        }
    }
}

#Preview {
    ContentView(context: PersistenceController.preview.container.viewContext)
}
