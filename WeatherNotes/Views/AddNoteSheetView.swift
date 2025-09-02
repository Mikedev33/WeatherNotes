//
//  AddNoteSheetView.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//

import SwiftUI

struct AddNoteSheetView: View {
    // Binding to show/hide the sheet
    @Binding var isPresented: Bool
    
    // Binding for the text input
    @State private var noteText: String = ""
    
    // Closure to call when saving the note
    var onSave: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Sheet title
                Text("New Note")
                    .font(.title2)
                    .bold()
                    .padding(.top)
                
                // Text input
                TextField("Enter note text...", text: $noteText)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Spacer()
                
                // Action buttons
                HStack(spacing: 20) {
                    // Cancel button
                    Button(role: .cancel) {
                        isPresented = false
                        noteText = ""
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                    }
                    
                    // Save button
                    Button {
                        if !noteText.isEmpty {
                            onSave(noteText)
                            noteText = ""
                            isPresented = false
                        }
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(noteText.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(noteText.isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    AddNoteSheetView(isPresented: .constant(true)) { text in
        print("Note saved: \(text)")
    }
}


