//
//  CityWeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI

class CityWeatherDetailViewModel: ObservableObject {
    @Published var city: String
    @Published var temperature: String
    @Published var weatherCondition: String
    @Published var highTemp: String
    @Published var lowTemp: String
    @Published var hourlyData: [(String, String, Int)]
    @Published var dailyData: [(String, String, Int, Int)]
    
    init(city: String, temperature: String = "23", weatherCondition: String = "Partly Cloudy", highTemp: String = "H:25°", lowTemp: String = "L:18°") {
        self.city = city
        self.temperature = temperature
        self.weatherCondition = weatherCondition
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        
        // Sample hourly forecast data
        self.hourlyData = [
            ("Now", "cloud.fill", 23),
            ("8PM", "cloud", 23),
            ("9PM", "cloud.moon.fill", 22),
            ("10PM", "cloud.moon", 21),
            ("11PM", "cloud.moon.fill", 21),
            ("12AM", "cloud.moon", 20)
        ]
        
        // Sample daily forecast data
        self.dailyData = [
            ("Today", "cloud.fill", 18, 25),
            ("Sat", "cloud", 19, 27),
            ("Sun", "cloud.fill", 20, 28),
            ("Mon", "cloud.sun.fill", 18, 29),
            ("Tue", "sun.max.fill", 17, 30)
        ]
    }
}
