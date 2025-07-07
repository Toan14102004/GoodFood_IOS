//
//  Dish.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation
import FirebaseFirestore

struct Dish: Codable, Identifiable {
    var id: UUID
    var name: String?
    var description: String?
    var image: String?
    var recipe: String?
    var ingredients: [IngredientLite]?
    var nutritionFacts: NutritionFacts?
    var dateTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, recipe, ingredients, nutritionFacts, dateTime
    }
    
    init(
        id: UUID,
        name: String? = nil,
        description: String? = nil,
        image: String? = nil,
        recipe: String? = nil,
        ingredients: [IngredientLite]? = nil,
        nutritionFacts: NutritionFacts? = nil,
        dateTime: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.recipe = recipe
        self.ingredients = ingredients
        self.nutritionFacts = nutritionFacts
        self.dateTime = dateTime
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        description = try? container.decode(String.self, forKey: .description)
        image = try? container.decode(String.self, forKey: .image)
        recipe = try? container.decode(String.self, forKey: .recipe)
        ingredients = try? container.decode([IngredientLite].self, forKey: .ingredients)
        nutritionFacts = try? container.decode(NutritionFacts.self, forKey: .nutritionFacts)
        
        // Xử lý dateTime:
        if let timestamp = try? container.decode(Timestamp.self, forKey: .dateTime) {
            dateTime = timestamp.dateValue()
        } else if let timeInterval = try? container.decode(Double.self, forKey: .dateTime) {
            dateTime = Date(timeIntervalSince1970: timeInterval)
        } else if let dateString = try? container.decode(String.self, forKey: .dateTime) {
            let formatter = ISO8601DateFormatter()
            dateTime = formatter.date(from: dateString)
        } else {
            dateTime = nil
        }
    }


}
