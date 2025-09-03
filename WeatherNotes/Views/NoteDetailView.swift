//
//  NoteDetailView.swift
//  WeatherNotes
//
//  Created by user on 03.09.2025.
//





import SwiftUI

struct NoteDetailView: View {
    let note: Note
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            
            // MARK: - Note text
            VStack(spacing: 12) {
                Text(note.text ?? "No text")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                
                if let date = note.timestamp {
                    Text(date, formatter: Formatters.noteDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            Spacer(minLength: 30)
            
            // MARK: - Weather card
            VStack(spacing: 16) {
                // Safe temperature
                let safeTemp = note.temperature.isNaN ? 0 : note.temperature
                Text(safeTemp != 0 ? "\(safeTemp, specifier: "%.1f")°C" : "--°C")
                    .font(.system(size: 50, weight: .bold))
                
                // Weather icon
                let iconName = (note.weatherIcon?.isEmpty == false) ? note.weatherIcon! : "cloud.sun.fill"
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                // Weather description
                Text(note.weatherDesc ?? "Fetching weather...")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: 250)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            
            Spacer()
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top)
    }
}

#Preview {
    // Preview using a dummy Note
    let context = PersistenceController.preview.container.viewContext
    let note = Note(context: context)
    note.text = "Morning Run"
    note.timestamp = Date()
    note.temperature = 23
    note.weatherIcon = "sun.max.fill"
    note.weatherDesc = "Clear sky"
    
    return NavigationView {
        NoteDetailView(note: note)
    }
}
