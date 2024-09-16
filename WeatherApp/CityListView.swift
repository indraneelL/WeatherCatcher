//
//  CityListView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI

// CityListView - uses the shared view model to update weather details
struct CityListView: View {
    @Binding var showCityListView: Bool
    var sharedViewModel: CityWeatherDetailViewModel // Use the shared view model
    
    // State to control showing the CitySearchView
    @State private var showCitySearchView = false
    
    // Closure to set the current page in CityWeatherDetailView
    var onSelectCity: (Int) -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(action: {
                    // Present the CitySearchView when the search bar is tapped
                    showCitySearchView = true
                })

                List {
                    Section(header: Text("Saved Cities").font(.headline)) {
                        ForEach(sharedViewModel.cities, id: \.city) { cityInfo in
                            Button(action: {
                                // Set the current page in CityWeatherDetailView
                                if let index = sharedViewModel.cities.firstIndex(where: { $0.city == cityInfo.city }) {
                                    onSelectCity(index)
                                }
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
                    // Add the newly searched city to the list
                    sharedViewModel.addCity(cityInfo)
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
