//
//  DishLite.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//
import Foundation

struct DishLite: Codable {
    var name: String
    var image: String?
    var recipe: String?
    var ingredients: [IngredientLite]
}
