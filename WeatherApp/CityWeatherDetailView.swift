//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI

struct CityWeatherDetailView: View {
    var city: String
    var temperature: String = "23"
    var weatherCondition: String = "Partly Cloudy"
    var highTemp: String = "H:25°"
    var lowTemp: String = "L:18°"

    // Dummy data for hourly forecast
    let hourlyData = [
        ("Now", "cloud.fill", 23),
        ("8PM", "cloud", 23),
        ("9PM", "cloud.moon.fill", 22),
        ("10PM", "cloud.moon", 21),
        ("11PM", "cloud.moon.fill", 21),
        ("12AM", "cloud.moon", 20)
    ]

    // Dummy data for 10-day forecast
    let dailyData = [
        ("Today", "cloud.fill", 18, 25),
        ("Sat", "cloud", 19, 27),
        ("Sun", "cloud.fill", 20, 28),
        ("Mon", "cloud.sun.fill", 18, 29),
        ("Tue", "sun.max.fill", 17, 30)
    ]

    var body: some View {
        ScrollView {
            VStack {
                // City and current temperature
                VStack(spacing: 10) {
                    Text(city)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Text("\(temperature)°")
                        .font(.system(size: 80))
                        .fontWeight(.thin)
                    Text(weatherCondition)
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("\(highTemp) \(lowTemp)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)

                // Hourly forecast
                VStack(alignment: .leading) {
                    Text("Cloudy conditions expected around 8PM.")
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(hourlyData, id: \.0) { hour in
                                VStack {
                                    Text(hour.0)
                                    Image(systemName: hour.1)
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                    Text("\(hour.2)°")
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding(.vertical, 20)

                // 10-day forecast
                VStack(alignment: .leading) {
                    Text("10-DAY FORECAST")
                        .font(.caption)
                        .foregroundColor(.gray)

                    ForEach(dailyData, id: \.0) { day in
                        HStack {
                            Text(day.0)
                                .frame(width: 70, alignment: .leading)
                            Image(systemName: day.1)
                                .font(.system(size: 25))
                                .frame(width: 30)
                            Spacer()
                            Text("\(day.2)°")
                                .frame(width: 30)
                            // Temperature bar
                            TemperatureBar(lowTemp: day.2, highTemp: day.3)
                            Spacer()
                            Text("\(day.3)°")
                                .frame(width: 30)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .background(Color(.systemGray6))
    }
}

// Temperature bar view for the 10-day forecast
struct TemperatureBar: View {
    var lowTemp: Int
    var highTemp: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(width: geo.size.width, height: 6)
                    .foregroundColor(.gray.opacity(0.3))

                Capsule()
                    .frame(width: CGFloat((highTemp - lowTemp) * 3), height: 6)
                    .foregroundColor(.yellow)
            }
        }
        .frame(height: 10)
    }
}

