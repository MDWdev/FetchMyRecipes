//
//  CuisineRecipesView.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI

struct CuisineRecipesView: View {
    @EnvironmentObject var recipesService: RecipesService
    
    let title: String
    let recipes: [Recipe]
    
    @State private var selectedUrl: URL?
    @State private var showMissingUrlAlert = false

    var body: some View {
        if recipes.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                
                Text("No recipes available.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        } else {
            List(recipes) { recipe in
                Button(action: {
                    if let urlString = recipe.sourceUrl, let url = URL(string: urlString) {
                        selectedUrl = url
                    } else {
                        showMissingUrlAlert = true
                    }
                }) {
                    RecipeCard(recipe: recipe)
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            .navigationTitle(title)
            .sheet(item: $selectedUrl) { url in
                SafariWrapper(url: url)
            }
            .refreshable {
                await recipesService.refreshAllRecipes()
            }
            .alert("Recipe Unavailable", isPresented: $showMissingUrlAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("This recipe doesn't have a valid source link.")
            }
            .alert("Error", isPresented: Binding<Bool>(
                get: { recipesService.errorMessage != nil },
                set: { if !$0 {
                    DispatchQueue.main.async {
                        recipesService.errorMessage = nil
                    }
                } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(recipesService.errorMessage ?? "")
            }
        }

    }
}

#Preview {
    CuisineRecipesView(title: "TEST", recipes: [Recipe.example])
}
