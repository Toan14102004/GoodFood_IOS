//
//  NutritionFacts.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//

import Foundation

struct NutritionFacts: Codable {
    var calories: Double?
    var fat: Double?
    var saturatedFat: Double?
    var protein: Double?
    var carbohydrates: Double?
    var sugar: Double?
    var fiber: Double?
    var cholesterol: Double?
    var sodium: Double?
    var calcium: Double?
    var iron: Double?
    var potassium: Double?

    enum CodingKeys: String, CodingKey {
        case calories, fat, saturatedFat, protein, carbohydrates, sugar, fiber, cholesterol, sodium, calcium, iron, potassium
    }

    init(
        calories: Double? = nil,
        fat: Double? = nil,
        saturatedFat: Double? = nil,
        protein: Double? = nil,
        carbohydrates: Double? = nil,
        sugar: Double? = nil,
        fiber: Double? = nil,
        cholesterol: Double? = nil,
        sodium: Double? = nil,
        calcium: Double? = nil,
        iron: Double? = nil,
        potassium: Double? = nil
    ) {
        self.calories = calories
        self.fat = fat
        self.saturatedFat = saturatedFat
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.sugar = sugar
        self.fiber = fiber
        self.cholesterol = cholesterol
        self.sodium = sodium
        self.calcium = calcium
        self.iron = iron
        self.potassium = potassium
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        calories = try? decodeNumber(forKey: .calories, in: container)
        fat = try? decodeNumber(forKey: .fat, in: container)
        saturatedFat = try? decodeNumber(forKey: .saturatedFat, in: container)
        protein = try? decodeNumber(forKey: .protein, in: container)
        carbohydrates = try? decodeNumber(forKey: .carbohydrates, in: container)
        sugar = try? decodeNumber(forKey: .sugar, in: container)
        fiber = try? decodeNumber(forKey: .fiber, in: container)
        cholesterol = try? decodeNumber(forKey: .cholesterol, in: container)
        sodium = try? decodeNumber(forKey: .sodium, in: container)
        calcium = try? decodeNumber(forKey: .calcium, in: container)
        iron = try? decodeNumber(forKey: .iron, in: container)
        potassium = try? decodeNumber(forKey: .potassium, in: container)
    }

    private func decodeNumber(forKey key: CodingKeys, in container: KeyedDecodingContainer<CodingKeys>) throws -> Double? {
        if let doubleValue = try? container.decode(Double.self, forKey: key) {
            return doubleValue
        } else if let intValue = try? container.decode(Int.self, forKey: key) {
            return Double(intValue)
        }
        return nil
    }
}
