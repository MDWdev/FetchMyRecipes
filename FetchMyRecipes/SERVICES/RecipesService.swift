//
//  RecipesService.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import Foundation

class RecipesService: NSObject {
    static let shared = RecipesService()
    
    private override init() {
        print("RecipesService initiated")
        
        super.init()
    }
}
