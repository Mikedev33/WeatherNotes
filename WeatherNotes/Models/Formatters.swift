//
//  Formatters.swift
//  WeatherNotes
//
//  Created by user on 03.09.2025.
//

import Foundation

/// Central place for reusable formatters
enum Formatters {
    /// Formatter for displaying note timestamps (date + time)
    static let noteDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short   // e.g. 03.09.25
        formatter.timeStyle = .medium  // e.g. 21:14:32
        return formatter
    }()
}

