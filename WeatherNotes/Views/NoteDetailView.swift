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
        VStack(spacing: 24) {
            // Note text
            Text(note.text ?? "No text")
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Date
            if let date = note.timestamp {
                Text(date, formatter: Formatters.noteDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Weather card
            VStack(spacing: 16) {
                Image(systemName: note.weatherIcon?.isEmpty == false ? note.weatherIcon! : "cloud.sun.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("\(note.temperature, specifier: "%.1f")°C")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                
                Text(note.weatherDesc?.capitalized ?? "No description")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .frame(width: 220, height: 220)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
            
            Spacer() 
        }
        .padding()
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}




