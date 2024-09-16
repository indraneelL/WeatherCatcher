//
//  CityInfo.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI


struct CityInfo: Codable, Identifiable {
    let id = UUID()
    let city: String
    let temperature: String
    let condition: String
    let highTemp: String
    let lowTemp: String
    let weather: [Weather]
    let coordinates: Coordinates
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}
