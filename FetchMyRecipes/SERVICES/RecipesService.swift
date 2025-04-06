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
    }
    
    func fetchAllRecipes() {
        self.runRequest(with: recipeDomain)
    }
    
    func filter(by cuisine: String) {
        filteredRecipes = allRecipes.filter { $0.cuisine == cuisine }
    }
    
    func resetFilter() {
        filteredRecipes = nil 
    }
    
    func clearEverything() {
        allRecipes = []
        filteredRecipes = nil
    }
    
    func getMalformed() {
        self.runRequest(with: malformedRecipes)
    }
    
    func getEmpty() {
        self.runRequest(with: emptyRecipes)
    }
    
    private func runRequest(with urlStr: String) {
            guard let url = URL(string: urlStr) else { return }

            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(RecipesResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.allRecipes = result.recipes ?? []
                            self.filteredRecipes = nil
                        }
                    } catch {
                        print("JSON decoding error:", error)
                    }
                } else if let error = error {
                    print("Network error:", error)
                }
            }.resume()
        }
}
