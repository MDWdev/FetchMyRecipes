//
//  RecipesService.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import Foundation



class RecipesService: ObservableObject {
    let recipeDomain = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    let malformedRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    let emptyRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    
    @Published var allRecipes: [Recipe]?
    
    private var lastRecipes: [Recipe]?
    private var lastRecipeLoad: Date?
    
    enum NetworkError: Error {
        case invalidData
        case invalidJSON
        case invalidResponse
    }
    
    init() {
        getRecipes()
    }
    
    func clearRecipes() {
        self.lastRecipes = nil
        self.lastRecipeLoad = nil
    }
    
    func getRecipes() {
        self.runRequest(with: recipeDomain)
    }
    
    func getMalformed() {
        self.runRequest(with: malformedRecipes)
    }
    
    func getEmpty() {
        self.runRequest(with: emptyRecipes)
    }
    
    func runRequest(with urlStr: String) {
        if let url = URL(string: urlStr) {
            let urlRequest = URLRequest(url: url)
            
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("getRecipes error: ", error?.localizedDescription ?? "")
                } else if data != nil {
                    print("getRecipes got data")
                    do {
                        let result = try JSONDecoder().decode(RecipesResponse.self, from: data!)
                        if let recipes = result.recipes {
                            DispatchQueue.main.async {
                                self.allRecipes = recipes
                            }
                        }
                    } catch {
                        print("getRecipes error: ", "JSON Error")
                    }
                }
            })
            task.resume()
        }
    }
    
    
}
