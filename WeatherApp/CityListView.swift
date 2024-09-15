//
//  CityListView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI


struct CityListView: View {
    @State private var showSearchView = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Tapping on the search field to trigger navigation to CitySearchView
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
                    showSearchView = true
                }
                .padding([.leading, .trailing])
                
                // City List with Navigation Links
                List {
                    Section(header: Text("Saved Cities").font(.headline)) {
                        ForEach(cityData) { cityInfo in
                            NavigationLink(destination: CityWeatherDetailView(city: cityInfo.city, temperature: cityInfo.temperature, weatherCondition: cityInfo.condition, highTemp: cityInfo.highTemp, lowTemp: cityInfo.lowTemp)) {
                                CityRow(city: cityInfo.city, temperature: cityInfo.temperature, condition: cityInfo.condition, highTemp: cityInfo.highTemp, lowTemp: cityInfo.lowTemp)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle()) // Clean list style
                
                // Navigation to the search view
                NavigationLink(destination: CitySearchView(), isActive: $showSearchView) {
                    EmptyView()
                }
            }
            .navigationTitle("Weather")
        }
    }
}

// Sample data for the cities
struct CityInfo: Identifiable {
    let id = UUID()
    let city: String
    let temperature: String
    let condition: String
    let highTemp: String
    let lowTemp: String
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

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}


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

