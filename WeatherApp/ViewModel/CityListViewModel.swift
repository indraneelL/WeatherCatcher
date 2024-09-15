//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI
import Combine

class CityListViewModel: ObservableObject {
    @Published var cities: [CityInfo] = []
    @Published var showSearchView = false
    
    init() {
        loadCities()
    }
    
    func loadCities() {
        // Load the sample data (can be fetched from API in a real app)
        cities = [
            CityInfo(city: "San Jose", temperature: "27°", condition: "Sunny", highTemp: "H:32°", lowTemp: "L:13°"),
            CityInfo(city: "Niagara Falls", temperature: "21°", condition: "Clear", highTemp: "H:27°", lowTemp: "L:15°"),
            CityInfo(city: "New Delhi", temperature: "23°", condition: "Mostly Cloudy", highTemp: "H:30°", lowTemp: "L:23°"),
            CityInfo(city: "Mumbai", temperature: "25°", condition: "Mostly Cloudy", highTemp: "H:28°", lowTemp: "L:25°"),
            CityInfo(city: "San Francisco", temperature: "18°", condition: "Mostly Sunny", highTemp: "H:21°", lowTemp: "L:13°"),
            CityInfo(city: "Reno", temperature: "26°", condition: "Sunny", highTemp: "H:27°", lowTemp: "L:8°")
        ]
    }
    
    func toggleSearchView() {
        showSearchView.toggle()
    }
}
