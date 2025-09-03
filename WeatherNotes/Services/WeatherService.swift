
//
//  WeatherService.swift
//  WeatherNotes
//
//  Created by user on 02.09.2025.
//

import Foundation
import CoreLocation

// MARK: - Raw data from OpenWeather API
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

// MARK: - Display-friendly weather data
struct WeatherDisplayData {
    let temperature: Double
    let description: String
    let icon: String
}

// MARK: - WeatherService
class WeatherService {
    private let apiKey: String
    
    init() {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["API_KEY"] as? String {
            self.apiKey = key
        } else {
            fatalError("API_KEY not found in Secrets.plist")
        }
    }
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherDisplayData, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
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
                
                // Safe temperature guard
                let rawTemp = weatherData.main.temp
                let safeTemp = rawTemp.isNaN ? 0.0 : rawTemp
                
                let desc = weatherData.weather.first?.description ?? "Clear sky"
                let iconCode = weatherData.weather.first?.icon ?? "01d"
                let icon = self.sfSymbol(for: iconCode)
                
                let displayData = WeatherDisplayData(
                    temperature: safeTemp,
                    description: desc,
                    icon: icon
                )
                
                completion(.success(displayData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Convert OpenWeather icon code to SF Symbol
    private func sfSymbol(for weatherIcon: String) -> String {
        switch weatherIcon {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d", "10n": return "cloud.heavyrain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "cloud.sun.fill"
        }
    }
}
