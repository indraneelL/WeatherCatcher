//
//  CitySearchView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI
import MapKit

struct CitySearchView: View {
    @State private var searchText = ""
    @StateObject private var completer = LocationSearchCompleter()
    @State private var selectedCity: String? = nil // Track the selected city for navigation

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search", text: $searchText, onEditingChanged: { _ in
                    completer.updateSearchResults(for: searchText)
                })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                Button("Cancel") {
                    // Dismiss the view or handle navigation back
                }
                .padding(.trailing)
            }
            
            // List of Search Results
            List(completer.searchResults, id: \.self) { result in
                NavigationLink(destination: CityWeatherDetailView(city: result.title), tag: result.title, selection: $selectedCity) {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .font(.headline)
                        Text(result.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onTapGesture {
                    selectedCity = result.title // Set the selected city
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: searchText) { newValue in
            completer.updateSearchResults(for: newValue)
        }
    }
}

class LocationSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchResults: [MKLocalSearchCompletion] = []
    private var searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
    }

    func updateSearchResults(for query: String) {
        searchCompleter.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = completer.results
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching search results: \(error.localizedDescription)")
    }
}


