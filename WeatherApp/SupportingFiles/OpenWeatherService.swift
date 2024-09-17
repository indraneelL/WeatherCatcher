//
//  OpenWeatherService.swift
//  WeatherApp
//
//  Created by indraneel on 16/09/24.
//

import Foundation
import CoreLocation

protocol WeatherService {
    func fetchWeatherForLocation(lat: Double, lon: Double, completion: @escaping (CityInfo?) -> Void)
}

class OpenWeatherService: WeatherService {
    private let apiKey: String
    private let session: URLSession
    
    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchWeatherForLocation(lat: Double, lon: Double, completion: @escaping (CityInfo?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
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
                
                let weather = weatherResponse.weather.map { weatherResp in
                    Weather(id: weatherResp.id, main: weatherResp.main, description: weatherResp.description, icon: weatherResp.icon)
                }
                
                let coordinates = Coordinates(lon: weatherResponse.coord.lon, lat: weatherResponse.coord.lat)
                
                let cityInfo = CityInfo(
                    city: weatherResponse.name,
                    temperature: "\(Int(weatherResponse.main.temp))°",
                    condition: weatherResponse.weather.first?.main ?? "N/A",
                    highTemp: "H:\(Int(weatherResponse.main.temp_max))°",
                    lowTemp: "L:\(Int(weatherResponse.main.temp_min))°",
                    weather: weather,
                    coordinates: coordinates
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
