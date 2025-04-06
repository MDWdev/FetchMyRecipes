//
//  ContentView.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var recipesService: RecipesService
    
    var body: some View {
        NavigationView {
            if let recipes = recipesService.allRecipes {
                List(recipes) { recipe in
                    Text(recipe.name)
                }
            }
        }
    }
}

#Preview {
    ContentView(recipesService: RecipesService())
}
