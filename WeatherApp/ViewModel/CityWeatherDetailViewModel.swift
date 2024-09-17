//
//  CityWeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import SwiftUI
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


class CityWeatherDetailViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cities: [CityInfo] = []
    
    private var locationManager: CLLocationManager
    private var weatherService: WeatherService
    
    init(locationManager: CLLocationManager = CLLocationManager(), weatherService: WeatherService) {
        self.locationManager = locationManager
        self.weatherService = weatherService
        super.init()
        loadSavedCities()
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            weatherService.fetchWeatherForLocation(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { cityInfo in
                if let cityInfo = cityInfo {
                    DispatchQueue.main.async {
                        self.addCity(cityInfo)
                    }
                }
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func addCity(_ cityInfo: CityInfo) {
        if !cities.contains(where: { $0.city == cityInfo.city }) {
            cities.append(cityInfo)
            saveCities()
        }
    }
    
    func saveCities() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(cities) {
            UserDefaults.standard.set(encodedData, forKey: "savedCities")
        }
    }
    
    func loadSavedCities() {
        if let savedData = UserDefaults.standard.data(forKey: "savedCities") {
            let decoder = JSONDecoder()
            if let savedCities = try? decoder.decode([CityInfo].self, from: savedData) {
                self.cities = savedCities
            }
        }
    }
    
    func updateWeatherForAllCities() {
        for city in cities {
            weatherService.fetchWeatherForLocation(lat: city.coordinates.lat, lon: city.coordinates.lon) { updatedCity in
                if let updatedCity = updatedCity {
                    if let index = self.cities.firstIndex(where: { $0.city == updatedCity.city }) {
                        DispatchQueue.main.async {
                            self.cities[index] = updatedCity
                        }
                    }
                }
            }
        }
    }
}

