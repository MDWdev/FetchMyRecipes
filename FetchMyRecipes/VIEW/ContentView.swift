//
//  ContentView.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var recipesService: RecipesService
    @State private var selectedCuisine: CuisineCategory?

    var body: some View {
        let _ = print("isLoading: \(recipesService.isLoading)")
        
        ZStack {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(recipesService.cuisines) { cuisine in
                            NavigationLink(
                                destination: CuisineRecipesView(
                                    title: cuisine.name,
                                    recipes: cuisine.name == "All Recipes"
                                        ? recipesService.allRecipes
                                        : recipesService.allRecipes.filter { $0.cuisine == cuisine.name }
                                )
                            ) {
                                ZStack {
                                    // Background Image
                                    if let imageUrl = cuisine.previewImageURL {
                                        CachedImageView(url: imageUrl)
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
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Browse Cuisines")
            }
            
            if recipesService.isLoading {
                LoadingOverlay()
            }
        }
        .animation(.easeInOut, value: recipesService.isLoading)
    }
}

#Preview {
    ContentView(recipesService: RecipesService())
}
