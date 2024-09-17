//
//  ImageLoader.swift
//  WeatherApp
//
//  Created by indraneel on 16/09/24.
//

import Foundation
import Combine
import SwiftUI

// ViewModel for Image Caching and Loading
class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: AnyCancellable?

    func loadImage(from urlString: String) {
        // Check if image is cached
        if let cachedImage = CacheManager.shared.getImage(for: urlString) {
            self.image = cachedImage
            return
        }

        // Download image if not cached
        guard let url = URL(string: urlString) else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self = self, let image = image else { return }
                CacheManager.shared.setImage(image, for: urlString)
                self.image = image
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

struct CachedAsyncImage: View {
    @StateObject private var imageLoader = ImageLoader()
    let urlString: String
    let placeholder: Image

    var body: some View {
        ZStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .onAppear {
                        imageLoader.loadImage(from: urlString)
                    }
                    .onDisappear {
                        imageLoader.cancel()
                    }
            }
        }
    }
}
