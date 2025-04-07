//
//  RecipesService.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import Foundation
import Combine

class RecipesService: ObservableObject {
    let recipeDomain = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let malformedRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let emptyRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    @Published var allRecipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe]? = nil
    @Published var isLoading: Bool = true
    @Published var loadedPreviewImages: Int = 0
    @Published var visibleTileTarget: Int = 0
    @Published var errorMessage: String?
    
    var recipesToShow: [Recipe] {
        filteredRecipes ?? allRecipes
    }
    
    var cuisines: [CuisineCategory] {
        let grouped = Dictionary(grouping: allRecipes, by: \.cuisine)
        
        let mapped = grouped.map { (key, recipes) in
                CuisineCategory(
                    name: key,
                    count: recipes.count,
                    previewImageURL: recipes.first?.photoUrlSmall // ✅ Pull image from first recipe
                )
            }
        
        let allCategory = CuisineCategory(name: "All Recipes", count: allRecipes.count, previewImageURL: nil)
        
        return [allCategory] + mapped.sorted { $0.name < $1.name }
    }
    
    init() {
        fetchAllRecipes()
//        fetchMalformed()
//        fetchEmpty()
    }
    
    func fetchAllRecipes() {
        self.runRequest(with: recipeDomain)
    }
    
    func filter(by cuisine: String) {
        DispatchQueue.main.async {
            self.filteredRecipes = self.allRecipes.filter { $0.cuisine == cuisine }
        }
    }
    
    func resetFilter() {
        DispatchQueue.main.async {
            self.filteredRecipes = nil
        }
    }
    
    func clearEverything() {
        DispatchQueue.main.async {
            self.allRecipes = []
            self.filteredRecipes = nil
        }
    }
    
    func fetchMalformed() {
        self.runRequest(with: malformedRecipes)
    }
    
    func fetchEmpty() {
        self.runRequest(with: emptyRecipes)
    }
    
    func refreshAllRecipes() async {
        DispatchQueue.main.async {
            self.errorMessage = nil
            self.isLoading = true
            self.loadedPreviewImages = 0
            self.visibleTileTarget = 0
        }
        
        await withCheckedContinuation { continuation in
            runRequest(with: recipeDomain) {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                continuation.resume()
            }
        }
    }
    
    private func runRequest(with urlStr: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlStr) else {
            completion?()
            return
        }

            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { completion? () }
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(RecipesResponse.self, from: data)
                        DispatchQueue.main.async {
                            if let recipes = result.recipes, !recipes.isEmpty, recipes.count > 0 {
                                self.allRecipes = recipes
                                self.filteredRecipes = nil
                            } else {
                                self.clearEverything()
                                self.isLoading = false
                            }
                        }
                    } catch {
                        print("JSON decoding error:", error)
                        DispatchQueue.main.async {
                            self.clearEverything()
                            self.isLoading = false
                            self.errorMessage = "Oops! We couldn't load recipes. Please try again later."
                        }
                    }
                } else if let error = error {
                    print("Network error:", error)
                    DispatchQueue.main.async {
                        self.clearEverything()
                        self.isLoading = false
                        self.errorMessage = "Oops! There was a problem with the network. Please try again later."
                    }
                }
            }.resume()
        }
}
