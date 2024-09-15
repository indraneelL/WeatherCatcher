//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI
import MapKit

class CitySearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchText: String = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var selectedCity: String? = nil
    private var searchCompleter = MKLocalSearchCompleter()

    override init() {
        super.init()
        searchCompleter.delegate = self
    }

    func updateSearchResults() {
        searchCompleter.queryFragment = searchText
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.searchResults = completer.results
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching search results: \(error.localizedDescription)")
    }

    func selectCity(_ city: String) {
        selectedCity = city
    }
}
