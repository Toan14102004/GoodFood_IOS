//
//  FoodInfo.swift
//  GoodFood_App
//
//  Created by Guest User on 5/8/25.
//
import Foundation

struct FoodInfo: Codable {
    let name: String
    let ingredients: [IngredientLite]
    let nutritionFacts: NutritionFacts
}
