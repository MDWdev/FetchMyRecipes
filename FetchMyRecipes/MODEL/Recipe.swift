//
//  Recipe.swift
//  FetchMyRecipes
//
//  Created by Melissa Webster on 4/4/25.
//

import Foundation

struct Recipe: Codable, Identifiable {
    var cuisine: String
    var name: String
    var photoUrlLarge: String?
    var photoUrlSmall: String?
    var id: UUID
    var sourceUrl: String?
    var youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case id = "uuid"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}

struct RecipesResponse: Codable {
    var recipes: [Recipe]?
}
