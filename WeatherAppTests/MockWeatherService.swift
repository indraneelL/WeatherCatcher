//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by indraneel on 16/09/24.
//

import Foundation

class MockWeatherService: WeatherService {
    var cityInfoToReturn: CityInfo?
    var fetchWeatherForLocationCalled = false
    
    func fetchWeatherForLocation(lat: Double, lon: Double, completion: @escaping (CityInfo?) -> Void) {
        fetchWeatherForLocationCalled = true
        completion(cityInfoToReturn)
    }
}
