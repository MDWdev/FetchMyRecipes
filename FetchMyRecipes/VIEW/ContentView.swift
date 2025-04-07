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
            NavigationView {
                
                GeometryReader { geometry in
                    let all = recipesService.allRecipes
                    if all.count > 0 {
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
                                DispatchQueue.main.async {
                                    recipesService.visibleTileTarget = targetCount
                                }
                            }
                        }
                    } else if all.count == 0 {
                        VStack(spacing: 16) {
                            Image(systemName: "fork.knife.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)

                            Text("No recipes available.")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                Task {
                                    await recipesService.refreshAllRecipes()
                                }
                            }) {
                                Label("Try Again", systemImage: "arrow.clockwise")
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
