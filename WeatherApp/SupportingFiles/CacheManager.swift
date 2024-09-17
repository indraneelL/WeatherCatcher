//
//  CacheManager.swift
//  WeatherApp
//
//  Created by indraneel on 16/09/24.
//

import Foundation
import Combine
import SwiftUI

// CacheManager to handle image caching
class CacheManager {
    static let shared = CacheManager()
    private init() {}

    private var cache: NSCache<NSString, UIImage> = NSCache()

    func getImage(for urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }

    func setImage(_ image: UIImage, for urlString: String) {
        cache.setObject(image, forKey: urlString as NSString)
    }
}
