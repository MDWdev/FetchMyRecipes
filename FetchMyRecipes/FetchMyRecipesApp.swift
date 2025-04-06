//
//  FetchMyRecipesApp.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import SwiftUI

@main
struct FetchMyRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(recipesService: RecipesService())
        }
    }
}
