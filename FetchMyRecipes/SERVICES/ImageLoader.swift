//
//  ImageLoader.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var didLoadImage = false
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }
    
    private func loadImage() {
        ImageCacheManager.shared.getCachedImage(for: urlString) { [weak self] cachedImage in
            if let cachedImage = cachedImage {
                DispatchQueue.main.async {
                    self?.image = cachedImage
                    self?.didLoadImage = true
                }
            } else {
                print("No cached image, downloading...")
                self?.downloadImage()
            }
        }
    }
    
    private func downloadImage() {
        guard let url = URL(string: urlString) else { return }
        
        print("📥 Downloading image from \(urlString)")

        
        URLSession.shared.dataTask(with: url) {data, _, _ in
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                ImageCacheManager.shared.cacheImage(image: downloadedImage, for: self.urlString)
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    self.didLoadImage = true
                }
            }
        }.resume()
    }
}
