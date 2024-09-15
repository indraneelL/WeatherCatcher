////
////  CitySearchViewModel.swift
////  WeatherApp
////
////  Created by indraneel on 15/09/24.
////
//
//import Foundation
//
//// MARK: - ViewModel for CitySearchView
//class CitySearchViewModel: ObservableObject {
//    @Published var searchText = ""
//    @Published var selectedCity: String? = nil
//    @Published var searchResults: [SearchResult] = []
//
//    private var completer = LocationSearchCompleter()
//
//    func updateSearchResults() {
//        completer.updateSearchResults(for: searchText)
//        searchResults = completer.searchResults
//    }
//}
