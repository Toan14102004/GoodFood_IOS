//
//  dishHistory.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.

import Foundation

struct DishHistory: Identifiable, Codable {
    var id: UUID = .init()
    var dateTime: Date
    var dish: Dish
    var ingredients: [IngredientLite]
    var nutritionFacts: NutritionFacts
}
