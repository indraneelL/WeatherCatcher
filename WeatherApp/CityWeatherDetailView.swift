//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI
import Combine

struct CityWeatherDetailView: View {
    @StateObject private var weatherViewModel: CityWeatherDetailViewModel
    @State private var showCityListView = false
    @State private var currentPage = 0

    init(viewModel: CityWeatherDetailViewModel) {
        _weatherViewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.gray.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                if weatherViewModel.cities.isEmpty {
                    Text("Loading weather details...")
                } else {
                    TabView(selection: $currentPage) {
                        ForEach(weatherViewModel.cities.indices, id: \.self) { index in
                            CityWeatherDetailPage(city: weatherViewModel.cities[index].city,
                                                  temperature: weatherViewModel.cities[index].temperature,
                                                  condition: weatherViewModel.cities[index].condition,
                                                  iconCode: weatherViewModel.cities[index].weather.first?.icon ?? "01d")
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    .onChange(of: currentPage) { newValue in
                        saveLastSelectedCityIndex(index: newValue)
                    }
                }
            }

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
        .onAppear {
            weatherViewModel.requestLocation()
            weatherViewModel.updateWeatherForAllCities()
            loadLastSelectedCityIndex()
        }
        .navigationTitle(weatherViewModel.cities.isEmpty ? "Loading..." : weatherViewModel.cities[currentPage].city)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGray6))
        .fullScreenCover(isPresented: $showCityListView) {
            CityListView(
                showCityListView: $showCityListView,
                sharedViewModel: weatherViewModel,
                onSelectCity: { index in
                    currentPage = index
                }
            )
        }
    }

    private func saveLastSelectedCityIndex(index: Int) {
        UserDefaults.standard.set(index, forKey: "LastSelectedCityIndex")
    }

    private func loadLastSelectedCityIndex() {
        if let savedIndex = UserDefaults.standard.value(forKey: "LastSelectedCityIndex") as? Int {
            if savedIndex < weatherViewModel.cities.count {
                currentPage = savedIndex
            }
        }
    }
}



// Main Weather Detail View using custom caching
struct CityWeatherDetailPage: View {
    var city: String
    var temperature: String
    var condition: String
    var iconCode: String // Weather icon code (e.g., "10d" for rain)

    var body: some View {
        ScrollView {
            ZStack {
                // Gradient background to cover the entire screen
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.gray.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 10) {
                    Text(city)
                        .font(.largeTitle)
                        .fontWeight(.medium)
                        .foregroundColor(.white)

                    Text(temperature)
                        .font(.system(size: 80))
                        .fontWeight(.thin)
                        .foregroundColor(.white)

                    Text(condition)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))

                    CachedAsyncImage(
                        urlString: "https://openweathermap.org/img/wn/\(iconCode)@2x.png",
                        placeholder: Image(systemName: "photo")
                    )
                    .frame(width: 150, height: 150) // Adjust width and height
                    .opacity(0.7)
                    .clipped()

                    Text("H:25° L:18°")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    VStack(alignment: .leading) {
                        Text("Cloudy conditions expected around 8PM.")
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<5, id: \.self) { index in
                                    VStack {
                                        Text("Now")
                                            .foregroundColor(.white)
                                        Image(systemName: "cloud.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white.opacity(0.7))
                                        Text("\(20 + index)°")
                                            .foregroundColor(.white)
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
                            .foregroundColor(.white.opacity(0.6))

                        ForEach(0..<5, id: \.self) { _ in
                            HStack {
                                Text("Today")
                                    .frame(width: 70, alignment: .leading)
                                    .foregroundColor(.white)

                                Image(systemName: "cloud.fill")
                                    .font(.system(size: 25))
                                    .frame(width: 30)
                                    .foregroundColor(.white)

                                Spacer()
                                Text("25°")
                                    .frame(width: 30)
                                    .foregroundColor(.white)

                                // Temperature bar
                                TemperatureBar(lowTemp: 18, highTemp: 25)

                                Spacer()
                                Text("25°")
                                    .frame(width: 30)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.top, 50)
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
