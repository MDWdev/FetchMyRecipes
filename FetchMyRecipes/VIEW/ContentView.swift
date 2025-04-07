//
//  ContentView.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var recipesService: RecipesService
    @State private var selectedCuisine: CuisineCategory?
    

    var body: some View {
        
        ZStack {
            let _ = print("is loading?: \(recipesService.isLoading)")
            NavigationView {
                
                GeometryReader { geometry in
                    let tileHeight: CGFloat = 160 + 20
                    let screenHeight = geometry.size.height
                    let numRows = Int(screenHeight / tileHeight)
                    let targetCount = numRows * 2
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(Array(recipesService.cuisines.enumerated()), id: \.element.id) { index, cuisine in
                                NavigationLink(
                                    destination: CuisineRecipesView(
                                        title: cuisine.name,
                                        recipes: cuisine.name == "All Recipes"
                                            ? recipesService.allRecipes
                                            : recipesService.allRecipes.filter { $0.cuisine == cuisine.name }
                                    )
                                ) {
                                    CuisineTile(cuisine: cuisine)
                                }
                            }
                        }
                        .padding()
                    }
                    .task {
                            if recipesService.visibleTileTarget != targetCount {
                                recipesService.visibleTileTarget = targetCount
                            }
                        }
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
    ContentView()
        .environmentObject(RecipesService())
}
