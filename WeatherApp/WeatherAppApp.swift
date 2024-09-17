//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI
import CoreLocation

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            let locationManager = CLLocationManager()
            let weatherService = OpenWeatherService(apiKey: "8cc43d02cd73e928346e5f95b875161a")
            let viewModel = CityWeatherDetailViewModel(locationManager: locationManager, weatherService: weatherService)

            CityWeatherDetailView(viewModel: viewModel)

        }
    }
}
