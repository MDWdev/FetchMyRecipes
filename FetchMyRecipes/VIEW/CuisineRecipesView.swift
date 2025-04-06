//
//  CuisineRecipesView.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI

struct CuisineRecipesView: View {
    let title: String
    let recipes: [Recipe]

    var body: some View {
        List(recipes) { recipe in
            RecipeCard(recipe: recipe)
        }
        .navigationTitle(title)
    }
}

#Preview {
    CuisineRecipesView(title: "TEST", recipes: [Recipe.example])
}
