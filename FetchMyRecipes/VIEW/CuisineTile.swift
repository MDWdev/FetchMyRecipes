//
//  CuisineTile.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI

struct CuisineTile: View {
    @EnvironmentObject var recipesService: RecipesService
    let cuisine: CuisineCategory
    
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            if let imageUrl = cuisine.previewImageURL {
                CachedImageView(url: imageUrl, onLoad: {
                    recipesService.loadedPreviewImages += 1
                    
                    if recipesService.loadedPreviewImages >= recipesService.visibleTileTarget {
                        recipesService.isLoading = false
                    }
                })
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.purple.opacity(0.6))
                    .frame(height: 160)
            }

            // Dark overlay
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(height: 160)

            // Text overlay
            VStack {
                Text(cuisine.name == "All Recipes" ? "ALL" : cuisine.name)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                
                Text("\(cuisine.count)")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.white.opacity(0.2)))
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.6), lineWidth: 1)
                    )
                    .padding(.top, 8)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
        .padding(.horizontal, 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 40)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                appeared = true
            }
        }
    }
}
