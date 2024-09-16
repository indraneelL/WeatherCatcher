//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI
import MapKit

class CitySearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [CitySearchResult] = []
    @Published var selectedCity: String?

    private let apiKey = "8cc43d02cd73e928346e5f95b875161a" // Replace with your OpenWeatherMap API key

    // Function to update search results (simulating search here)
    func updateSearchResults() {
        // Use LocationSearchCompleter or any logic to fetch results, here we're simulating with static data
        searchResults = [
            CitySearchResult(title: "New York", subtitle: "NY, USA"),
            CitySearchResult(title: "San Francisco", subtitle: "CA, USA"),
            CitySearchResult(title: "Los Angeles", subtitle: "CA, USA")
        ]
    }
    
    // Function to fetch weather details from OpenWeatherMap API
    func fetchWeather(for cityName: String, completion: @escaping (CityInfo?) -> Void) {
        let cityQuery = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                let cityInfo = CityInfo(
                    city: cityName,
                    temperature: "\(Int(weatherResponse.main.temp))°",
                    condition: weatherResponse.weather.first?.main ?? "N/A",
                    highTemp: "H:\(Int(weatherResponse.main.temp_max))°",
                    lowTemp: "L:\(Int(weatherResponse.main.temp_min))°"
                )
                completion(cityInfo)
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

// Struct to hold OpenWeatherMap response
struct OpenWeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let main: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

// Model for City Search Result
struct CitySearchResult: Hashable {
    let title: String
    let subtitle: String
}

