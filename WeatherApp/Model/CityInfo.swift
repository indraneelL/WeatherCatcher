//
//  CityInfo.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI

// Sample data for the cities
struct CityInfo: Identifiable {
    let id = UUID()
    let city: String
    let temperature: String
    let condition: String
    let highTemp: String
    let lowTemp: String
}
