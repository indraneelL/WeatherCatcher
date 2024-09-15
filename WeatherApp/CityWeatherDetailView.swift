//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI

struct CityWeatherDetailView: View {
    @StateObject private var viewModel: CityWeatherDetailViewModel
    
    init(city: String, temperature: String = "23", weatherCondition: String = "Partly Cloudy", highTemp: String = "H:25°", lowTemp: String = "L:18°") {
        _viewModel = StateObject(wrappedValue: CityWeatherDetailViewModel(city: city, temperature: temperature, weatherCondition: weatherCondition, highTemp: highTemp, lowTemp: lowTemp))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                // City and current temperature
                VStack(spacing: 10) {
                    Text(viewModel.city)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Text("\(viewModel.temperature)°")
                        .font(.system(size: 80))
                        .fontWeight(.thin)
                    Text(viewModel.weatherCondition)
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("\(viewModel.highTemp) \(viewModel.lowTemp)")
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
                            ForEach(viewModel.hourlyData, id: \.0) { hour in
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

                    ForEach(viewModel.dailyData, id: \.0) { day in
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

struct CityWeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityWeatherDetailView(city: "San Francisco")
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

