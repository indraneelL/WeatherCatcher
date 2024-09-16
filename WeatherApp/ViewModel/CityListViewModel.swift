//
//  CityListViewModel.swift
//  WeatherApp
//
//  Created by indraneel on 15/09/24.
//

import Foundation
import SwiftUI
import Combine

class CityListViewModel: ObservableObject {
    @Published var cities: [CityInfo] = []
    @Published var showSearchView = false

    func toggleSearchView() {
        showSearchView.toggle()
    }
}
