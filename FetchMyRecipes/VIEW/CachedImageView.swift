//
//  CachedImageView.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI

struct CachedImageView: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(urlString: url))
        self.placeholder = placeholder
        
        print("🖼️ CachedImageView for URL: \(url)")
    }
    
    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
    }
}
