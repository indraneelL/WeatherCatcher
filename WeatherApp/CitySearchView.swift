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

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search", text: $viewModel.searchText, onEditingChanged: { _ in
                    viewModel.updateSearchResults()
                })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.leading, .trailing])
                
                Button("Cancel") {
                    // Handle navigation back or dismissal
                }
                .padding(.trailing)
            }
            
            // List of Search Results
            List(viewModel.searchResults, id: \.self) { result in
                NavigationLink(
                    destination: CityWeatherDetailView(city: result.title),
                    tag: result.title,
                    selection: $viewModel.selectedCity
                ) {
                    VStack(alignment: .leading) {
                        Text(result.title)
                            .font(.headline)
                        Text(result.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onTapGesture {
                    viewModel.selectCity(result.title)
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

struct CitySearchView_Previews: PreviewProvider {
    static var previews: some View {
        CitySearchView()
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


