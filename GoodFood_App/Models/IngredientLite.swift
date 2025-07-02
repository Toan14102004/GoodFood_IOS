//
//  IngredientLite.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//

import Foundation

struct IngredientLite: Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var unit: String?
    var state: String?
    var quantity: Double
}

