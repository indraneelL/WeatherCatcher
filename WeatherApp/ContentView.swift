//
//  ContentView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var cityName: String = ""
    @State private var weatherInfo: String = "Enter city name to get weather"

    var body: some View {
        VStack(spacing: 20) {
            Text("Weather App")
                .font(.largeTitle)
                .bold()
            
            TextField("Enter city name", text: $cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Fetch weather data
                fetchWeather()
            }) {
                Text("Get Weather")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text(weatherInfo)
                .padding()
                .font(.body)
        }
        .padding()
    }

    // Placeholder function for fetching weather
    func fetchWeather() {
        weatherInfo = "Fetching weather for \(cityName)..."
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
