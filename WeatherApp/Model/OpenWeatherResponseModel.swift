//
//  OpenWeatherResponseModel.swift
//  WeatherApp
//
//  Created by indraneel on 16/09/24.
//

import Foundation

struct OpenWeatherResponse: Codable {
    let name: String
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


struct CitySearchResult: Hashable {
    let title: String
    let subtitle: String
}

