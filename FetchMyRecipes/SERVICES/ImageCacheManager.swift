//
//  ImageCacheManager.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private var cacheUrl: URL?
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private init() {
        setupDiskCacheDirectory()
    }
    
    func setupDiskCacheDirectory() {
        let fileManager = FileManager.default
        if let cachesDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let imageCacheDir = cachesDir.appendingPathComponent("ImageCache")
            
            if !fileManager.fileExists(atPath: imageCacheDir.path) {
                do {
                    try fileManager.createDirectory(at: imageCacheDir, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Failed to create image cache directory: \(error)")
                }
            }
            
            self.cacheUrl = imageCacheDir
        }
    }
    
    private func saveImage(image: UIImage, for urlStr: String) {
        let key = urlStr as NSString
        memoryCache.setObject(image, forKey: key)
        
        guard let cacheUrl = cacheUrl else { return }
        
        let fileUrl = cacheUrl.appendingPathComponent(urlStr.sha256())
        if let data = image.pngData() {
            do {
                try data.write(to: fileUrl)
            } catch {
                print("Failed to write image to disk: \(error)")
            }
        }
    }
    
    private func loadImage(for urlStr: String, completion: @escaping (UIImage?) -> Void) {
        let key = urlStr as NSString //for ease of use with NSCache
        
        if let cachedImg = memoryCache.object(forKey: key) {
            completion(cachedImg)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let cacheUrl = self.cacheUrl else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            let fileUrl = cacheUrl.appendingPathComponent(urlStr.sha256())
            
            if FileManager.default.fileExists(atPath: fileUrl.path), let data = try? Data(contentsOf: fileUrl), let image = UIImage(data: data) {
                self.memoryCache.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    
    // public methods
    func cacheImage(image: UIImage, for url: String) {
        saveImage(image: image, for: url)
    }
    
    func getCachedImage(for url: String, completion: @escaping (UIImage?) -> Void) {
        loadImage(for: url, completion: completion)
    }
}

