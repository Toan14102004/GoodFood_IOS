//
//  Dish.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation

//struct Dish: Codable, Identifiable {
//    var id: UUID = .init()
//    var image: String?
//    var name: String
//    var description: String
//    var ingredients: [Ingredient]?
//    var recipe: String?
//}
struct Dish: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var image: String?
    var recipe: String?
    var ingredients: [IngredientLite]?
    var nutritionFacts: NutritionFacts?
}
