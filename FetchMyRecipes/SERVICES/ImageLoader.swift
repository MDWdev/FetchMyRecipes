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
    
    private let urlString: String
    
    init(urlString: String) {
        self.urlString = urlString
        loadImage()
    }
    
    private func loadImage() {
        ImageCacheManager.shared.getCachedImage(for: urlString) { [weak self] cachedImage in
            if let cachedImage = cachedImage {
                self?.image = cachedImage
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
                self.image = downloadedImage
            }
        }.resume()
    }
}
