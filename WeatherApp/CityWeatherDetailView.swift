//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI

struct CityWeatherDetailView: View {
    @StateObject private var weatherViewModel = CityWeatherDetailViewModel()
    @StateObject private var cityListViewModel = CityListViewModel()
    @State private var showCityListView = false
    @State private var currentPage = 0 // Track current page for the TabView (page control)

    var body: some View {
        ZStack {
            VStack {
                if weatherViewModel.cities.isEmpty {
                    Text("Loading weather details...")
                        .onAppear {
                            weatherViewModel.requestLocation()
                        }
                } else {
                    TabView(selection: $currentPage) {
                        ForEach(weatherViewModel.cities.indices, id: \.self) { index in
                            CityWeatherDetailPage(city: weatherViewModel.cities[index].city, temperature: weatherViewModel.cities[index].temperature)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
            }

            // Bottom-right Burger Icon for navigation to CityListView
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showCityListView = true
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                }
            }
        }
        .navigationTitle(weatherViewModel.city)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $showCityListView) {
            CityListView(
                showCityListView: $showCityListView,
                sharedViewModel: weatherViewModel,
                cityListViewModel: cityListViewModel,
                onSelectCity: { index in
                    currentPage = index
                }
            )
        }
    }
}




struct CityWeatherDetailPage: View {
    var city: String
    var temperature: String

    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 10) {
                    Text(city)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Text(temperature)
                        .font(.system(size: 80))
                        .fontWeight(.thin)
                    Text("Partly Cloudy")
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("H:25° L:18°")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)

                VStack(alignment: .leading) {
                    Text("Cloudy conditions expected around 8PM.")
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(0..<5, id: \.self) { index in
                                VStack {
                                    Text("Now")
                                    Image(systemName: "cloud.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                    Text("\(20 + index)°")
                                }
                                .padding()
                            }
                        }
                    }
                }
                .padding(.vertical, 20)

                VStack(alignment: .leading) {
                    Text("10-DAY FORECAST")
                        .font(.caption)
                        .foregroundColor(.gray)

                    ForEach(0..<5, id: \.self) { _ in
                        HStack {
                            Text("Today")
                                .frame(width: 70, alignment: .leading)
                            Image(systemName: "cloud.fill")
                                .font(.system(size: 25))
                                .frame(width: 30)
                            Spacer()
                            Text("25°")
                                .frame(width: 30)
                            // Temperature bar
                            TemperatureBar(lowTemp: 18, highTemp: 25)
                            Spacer()
                            Text("25°")
                                .frame(width: 30)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

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
