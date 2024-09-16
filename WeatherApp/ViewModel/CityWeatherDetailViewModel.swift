//
//  CityWeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import SwiftUI

class CityWeatherDetailViewModel: ObservableObject {
    @Published var city: String
    @Published var temperature: String
    @Published var weatherCondition: String
    @Published var highTemp: String
    @Published var lowTemp: String
    @Published var cities: [CityInfo] = cityData // Use the sample city data initially
    
    init(city: String, temperature: String, weatherCondition: String, highTemp: String, lowTemp: String) {
        self.city = city
        self.temperature = temperature
        self.weatherCondition = weatherCondition
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }
    
    func updateWeatherDetails(city: String, temperature: String, weatherCondition: String, highTemp: String, lowTemp: String) {
        self.city = city
        self.temperature = temperature
        self.weatherCondition = weatherCondition
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }
    
    func addCity(_ cityInfo: CityInfo) {
        cities.append(cityInfo)
    }
}
