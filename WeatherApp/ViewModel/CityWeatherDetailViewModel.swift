//
//  CityWeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import SwiftUI
import CoreLocation


class CityWeatherDetailViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var city: String = "Loading..."
    @Published var temperature: String = ""
    @Published var weatherCondition: String = ""
    @Published var highTemp: String = ""
    @Published var lowTemp: String = ""
    @Published var cities: [CityInfo] = []
    
    private var locationManager: CLLocationManager?
    private let apiKey = "8cc43d02cd73e928346e5f95b875161a"
    
    override init() {
        super.init()
        requestLocation()
    }
    
    func requestLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    // CLLocationManagerDelegate method to get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchWeatherForLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { cityInfo in
                if let cityInfo = cityInfo {
                    DispatchQueue.main.async {
                        self.addCity(cityInfo)
                    }
                }
            }
        }
        manager.stopUpdatingLocation() // Stop updating location once we get it
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    // Fetch weather using latitude and longitude
    func fetchWeatherForLocation(lat: Double, lon: Double, completion: @escaping (CityInfo?) -> Void) {
        print("performing api call to fetch current location details")
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
            print("response_Data for current location")
            print(data)
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
    
    // Add city to the list
    func addCity(_ cityInfo: CityInfo) {
        // Check if the city already exists in the list
        if !cities.contains(where: { $0.city == cityInfo.city }) {
            cities.append(cityInfo)
        }
    }
}
