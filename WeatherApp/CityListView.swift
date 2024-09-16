//
//  CityListView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI

// CityListView - uses the shared viewModel to update weather details
struct CityListView: View {
    @StateObject private var viewModel = CityListViewModel()
    @Binding var showCityListView: Bool
    var sharedViewModel: CityWeatherDetailViewModel
    
    // State to control showing the CitySearchView
    @State private var showCitySearchView = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(action: {
                    // Present the CitySearchView when the search bar is tapped
                    showCitySearchView = true
                })

                List {
                    Section(header: Text("Saved Cities").font(.headline)) {
                        ForEach(viewModel.cities, id: \.city) { cityInfo in
                            Button(action: {
                                // Update the shared ViewModel and dismiss the list
                                sharedViewModel.updateWeatherDetails(
                                    city: cityInfo.city,
                                    temperature: cityInfo.temperature,
                                    weatherCondition: cityInfo.condition,
                                    highTemp: cityInfo.highTemp,
                                    lowTemp: cityInfo.lowTemp
                                )
                                showCityListView = false // Dismiss the view
                            }) {
                                CityRow(city: cityInfo.city, temperature: cityInfo.temperature, condition: cityInfo.condition, highTemp: cityInfo.highTemp, lowTemp: cityInfo.lowTemp)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Select a City")
            // Present CitySearchView as a sheet
            .sheet(isPresented: $showCitySearchView) {
                CitySearchView(isPresented: $showCitySearchView) { cityInfo in
                    // Add selected city to the viewModel
                    viewModel.cities.append(cityInfo)
                    sharedViewModel.addCity(cityInfo) // Sync with shared view model
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// SearchBarView - reusable component for search bar
struct SearchBarView: View {
    var action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            Text("Search for a city or airport")
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
        .padding([.leading, .trailing])
    }
}


// Sample data array
let cityData = [
    CityInfo(city: "San Jose", temperature: "27°", condition: "Sunny", highTemp: "H:32°", lowTemp: "L:13°"),
    CityInfo(city: "Niagara Falls", temperature: "21°", condition: "Clear", highTemp: "H:27°", lowTemp: "L:15°"),
    CityInfo(city: "New Delhi", temperature: "23°", condition: "Mostly Cloudy", highTemp: "H:30°", lowTemp: "L:23°"),
    CityInfo(city: "Mumbai", temperature: "25°", condition: "Mostly Cloudy", highTemp: "H:28°", lowTemp: "L:25°"),
    CityInfo(city: "San Francisco", temperature: "18°", condition: "Mostly Sunny", highTemp: "H:21°", lowTemp: "L:13°"),
    CityInfo(city: "Reno", temperature: "26°", condition: "Sunny", highTemp: "H:27°", lowTemp: "L:8°")
]

// CityRow - display city details in a row
struct CityRow: View {
    var city: String
    var temperature: String
    var condition: String
    var highTemp: String
    var lowTemp: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(city)
                        .font(.headline)
                    Text(condition)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(temperature)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            HStack {
                Text(highTemp)
                    .font(.footnote)
                Spacer()
                Text(lowTemp)
                    .font(.footnote)
            }
        }
        .padding()
    }
}
