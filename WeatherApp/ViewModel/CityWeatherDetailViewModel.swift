//
//  CityWeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import SwiftUI
import CoreLocation

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

