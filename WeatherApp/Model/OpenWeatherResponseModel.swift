//
//  OpenWeatherResponseModel.swift
//  WeatherApp
//
//  Created by indraneel on 16/09/24.
//

import Foundation

struct OpenWeatherResponse: Codable {
    let coord: CoordinatesResponse
    let weather: [WeatherResponse]
    let main: MainResponse
    let visibility: Int
    let wind: WindResponse
    let clouds: CloudsResponse
    let dt: Int
    let sys: SysResponse
    let timezone: Int
    let name: String
    let cod: Int
}

struct CoordinatesResponse: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherResponse: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainResponse: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct WindResponse: Codable {
    let speed: Double
    let deg: Int
}

struct CloudsResponse: Codable {
    let all: Int
}

struct SysResponse: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct CitySearchResult: Hashable {
    let title: String
    let subtitle: String
}

