//
//  RecipeCard.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/6/25.
//

import SwiftUI

struct RecipeCard: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            if let url = recipe.photoUrlSmall {
                CachedImageView(url: url)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Text(recipe.name)
        }
    }
}

#Preview {
    RecipeCard(recipe: Recipe.example)
}
