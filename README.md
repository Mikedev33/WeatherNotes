# WeatherNotes

WeatherNotes is a mini iOS app built in **SwiftUI** that allows users to create notes with automatic weather information for the current location.

## Features

- Add, view, and delete notes
- Each note displays:
  - Text
  - Timestamp
  - Temperature & weather icon
- Detailed view for each note with full weather description
- Fetches weather from OpenWeather API
- Local data storage using CoreData
- Supports light & dark mode

## Architecture

- MVVM (Model-View-ViewModel)
- Network layer separated (`WeatherService`)
- Location handled via `LocationManager`
- Persistent storage via CoreData
- Views modularized (`Views`, `ViewModels`, `Services`, `Models`)

## Installation

1. Open `WeatherNotes.xcodeproj` in Xcode
2. Add your OpenWeather API key in `Secrets.plist` (key: `API_KEY`)
3. Build and run on a simulator or device

## Usage

- Tap the **+** button to add a new note.
- The app will automatically fetch current weather.
- Tap a note to see full details including temperature and weather description.


