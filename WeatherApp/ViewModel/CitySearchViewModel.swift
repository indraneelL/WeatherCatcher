//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI
import MapKit

class CitySearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchText: String = ""
    @Published var searchResults: [CitySearchResult] = []
    @Published var selectedCity: String?

    private let apiKey = "8cc43d02cd73e928346e5f95b875161a" // Replace with your OpenWeatherMap API key
    private var searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }

    func updateSearchResults() {
        searchCompleter.queryFragment = searchText
    }

    // Delegate method to update search results
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = completer.results.map { result in
                CitySearchResult(title: result.title, subtitle: result.subtitle)
            }
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching search results: \(error.localizedDescription)")
    }

    // Function to perform a location search based on selected city name, retrieve coordinates, and fetch weather data
    func searchForCoordinates(cityName: String, completion: @escaping (CityInfo?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = cityName
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let error = error {
                print("Error during location search: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Get the first matching location's coordinates
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                let lat = coordinate.latitude
                let lon = coordinate.longitude
                self.fetchWeatherForCoordinates(lat: lat, lon: lon, cityName: cityName, completion: completion)
            } else {
                completion(nil)
            }
        }
    }

    // Fetch weather details using latitude and longitude
    func fetchWeatherForCoordinates(lat: Double, lon: Double, cityName: String, completion: @escaping (CityInfo?) -> Void) {
        print("Performing API call to fetch weather details using coordinates")
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
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
            print("response_Data for search")
            print(data)
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

