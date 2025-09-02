//
//  WeatherService.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//


import Foundation
import CoreLocation

// Structs to decode JSON response from OpenWeather
struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: String
        let icon: String
        let description: String
    }
}

class WeatherService {
    private let apiKey: String
    
    init() {
        // Load API key from Secrets.plist
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["API_KEY"] as? String {
            self.apiKey = key
        } else {
            fatalError("API_KEY not found in Secrets.plist")
        }
    }
    
    // Fetch weather data for given coordinates
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
//        print("📍 Fetching weather for lat=\(lat), lon=\(lon) with API key \(apiKey.prefix(5))...")

        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data returned", code: 0)))
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
