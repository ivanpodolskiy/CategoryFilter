//
//  APIRecipe.swift
//  FilterCategories
//
//  Created by user on 10.09.2023.
//

import Foundation

struct Result: Codable {
   let count: Int
    let hits: [Hit]
    enum CodingKeys: String, CodingKey {
        case count
        case hits
    }
}
// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe?
    enum CodingKeys: String, CodingKey {
        case recipe
    }
}
// MARK: - Recipe
struct Recipe: Codable {
    let label, url: String
    let calories: Double?
    
    enum CodingKeys: String, CodingKey {
    case label,  url,  calories
    }
}
