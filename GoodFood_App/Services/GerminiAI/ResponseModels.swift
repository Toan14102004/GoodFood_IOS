//
//  ResponseModels.swift
//  GoodFood_App
//
//  Created by Guest User on 30/7/25.
//
import Foundation

struct GeminiDishResponse: Codable {
    let name: String
    let ingredients: [IngredientLite]
    let nutritionFacts: NutritionFacts?
}

struct DishSuggestion: Codable {
    let name: String
    let ingredients: [IngredientLite]
    let description: String?
    let recipe: String
    let nutritionFacts: NutritionFacts
}
