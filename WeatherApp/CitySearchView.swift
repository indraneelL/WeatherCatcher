//
//  CitySearchView.swift
//  WeatherApp
//
//  Created by indraneel on 13/09/24.
//

import SwiftUI
import MapKit

struct CitySearchView: View {
    @StateObject private var viewModel = CitySearchViewModel()
    @Binding var isPresented: Bool
    
    // Callback when a city is selected
    var onCitySelected: (CityInfo) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                TextField("Search", text: $viewModel.searchText, onEditingChanged: { _ in
                    viewModel.updateSearchResults()
                })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                
                Button("Cancel") {
                    isPresented = false
                }
                .padding(.trailing)
            }
            
            // List of Search Results
            List(viewModel.searchResults, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text(result.title)
                        .font(.headline)
                    Text(result.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    // Fetch weather details using the coordinates from the city name
                    viewModel.searchForCoordinates(cityName: result.title) { cityInfo in
                        if let cityInfo = cityInfo {
                            DispatchQueue.main.async {
                                // Pass the weather info back to the parent and dismiss the view
                                onCitySelected(cityInfo)
                                isPresented = false
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.searchText) { _ in
            viewModel.updateSearchResults()
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


