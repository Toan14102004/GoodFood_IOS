//
//  IngredientNutrition.swift
//  GoodFood_App
//
//  Created by Guest User on 8/7/25.
//
import Foundation

struct IngredientNutrition {
    var name: String
    var category: String?
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var saturatedFat: Double?
    var sugar: Double?
    var fiber: Double?
    var cholesterol: Double?
    var sodium: Double?
    var calcium: Double?
    var iron: Double?
    var potassium: Double?
}


let ingredients: [IngredientNutrition] = [
    IngredientNutrition(name: "Ức gà không da", calories: 165, protein: 31, carbs: 0, fat: 3.6, saturatedFat: 1.0, sugar: 0, fiber: 0, cholesterol: 85, sodium: 74, calcium: 15, iron: 0.9, potassium: 256),
    IngredientNutrition(name: "Đùi gà", calories: 209, protein: 26, carbs: 0, fat: 11, saturatedFat: 3, sugar: 0, fiber: 0, cholesterol: 94, sodium: 84, calcium: 12, iron: 0.7, potassium: 239),
    IngredientNutrition(name: "Thịt bò nạc", calories: 250, protein: 26, carbs: 0, fat: 15, saturatedFat: 6, sugar: 0, fiber: 0, cholesterol: 90, sodium: 72, calcium: 18, iron: 2.6, potassium: 318),
    IngredientNutrition(name: "Thịt heo nạc", calories: 242, protein: 27, carbs: 0, fat: 14, saturatedFat: 5, sugar: 0, fiber: 0, cholesterol: 80, sodium: 62, calcium: 11, iron: 1.1, potassium: 287),
    IngredientNutrition(name: "Thịt vịt", calories: 337, protein: 27, carbs: 0, fat: 28, saturatedFat: 9, sugar: 0, fiber: 0, cholesterol: 84, sodium: 63, calcium: 11, iron: 2.7, potassium: 186),
    IngredientNutrition(name: "Cá hồi", calories: 208, protein: 20, carbs: 0, fat: 13, saturatedFat: 3, sugar: 0, fiber: 0, cholesterol: 63, sodium: 59, calcium: 9, iron: 0.5, potassium: 363),
    IngredientNutrition(name: "Cá ngừ", calories: 132, protein: 28, carbs: 0, fat: 1, saturatedFat: 0.2, sugar: 0, fiber: 0, cholesterol: 38, sodium: 50, calcium: 4, iron: 1.3, potassium: 522),
    IngredientNutrition(name: "Tôm", calories: 99, protein: 24, carbs: 0.2, fat: 0.3, saturatedFat: 0.1, sugar: 0, fiber: 0, cholesterol: 189, sodium: 111, calcium: 70, iron: 2.4, potassium: 264),
    IngredientNutrition(name: "Cua", calories: 97, protein: 20, carbs: 0, fat: 1.5, saturatedFat: 0.2, sugar: 0, fiber: 0, cholesterol: 53, sodium: 539, calcium: 91, iron: 0.8, potassium: 259),
    IngredientNutrition(name: "Mực", calories: 92, protein: 15.6, carbs: 3.1, fat: 1.4, saturatedFat: 0.4, sugar: 0, fiber: 0, cholesterol: 233, sodium: 44, calcium: 32, iron: 0.4, potassium: 246),
    IngredientNutrition(name: "Ghẹ",calories: 97,protein: 19.4,carbs: 0.0,fat: 1.5,saturatedFat:0.2,sugar: 0.0,fiber: 0.0,cholesterol: 59,sodium: 395,calcium: 91,iron: 0.8,potassium: 259),
    IngredientNutrition(name: "Hàu",calories: 68,protein: 7.0,carbs: 4.9,fat: 2.5,saturatedFat: 0.7,sugar: 0.0,fiber: 0.0,cholesterol: 42,sodium: 90,calcium: 59,iron: 6.7,potassium: 168),
    IngredientNutrition(name: "Trứng gà", calories: 155, protein: 13, carbs: 1.1, fat: 11, saturatedFat: 3.3, sugar: 1.1, fiber: 0, cholesterol: 373, sodium: 124, calcium: 50, iron: 1.2, potassium: 126),
    IngredientNutrition(name: "Đậu hũ", calories: 76, protein: 8, carbs: 1.9, fat: 4.8, saturatedFat: 0.7, sugar: 0.6, fiber: 0.3, cholesterol: 0, sodium: 7, calcium: 350, iron: 5.4, potassium: 121),
    IngredientNutrition(name: "Gạo trắng", calories: 130, protein: 2.4, carbs: 28, fat: 0.3, saturatedFat: 0.1, sugar: 0, fiber: 0.4, cholesterol: 0, sodium: 1, calcium: 10, iron: 1.2, potassium: 35),
    IngredientNutrition(name: "Gạo lứt", calories: 111, protein: 2.6, carbs: 23, fat: 0.9, saturatedFat: 0.2, sugar: 0.2, fiber: 1.8, cholesterol: 0, sodium: 5, calcium: 3, iron: 0.4, potassium: 43),
    IngredientNutrition(name: "Khoai lang", calories: 86, protein: 1.6, carbs: 20, fat: 0.1, saturatedFat: 0, sugar: 4.2, fiber: 3, cholesterol: 0, sodium: 55, calcium: 30, iron: 0.6, potassium: 337),
    IngredientNutrition(name: "Khoai tây", calories: 77, protein: 2, carbs: 17, fat: 0.1, saturatedFat: 0, sugar: 0.8, fiber: 2.2, cholesterol: 0, sodium: 6, calcium: 11, iron: 0.8, potassium: 429),
    IngredientNutrition(name: "Bún", calories: 110, protein: 2, carbs: 25, fat: 0.2, saturatedFat: 0, sugar: 0.5, fiber: 1, cholesterol: 0, sodium: 1, calcium: 5, iron: 0.5, potassium: 12),
    IngredientNutrition(name: "Mì gói", calories: 436, protein: 10, carbs: 55, fat: 20, saturatedFat: 9, sugar: 2, fiber: 2, cholesterol: 0, sodium: 1725, calcium: 35, iron: 4.7, potassium: 144),
    IngredientNutrition(name: "Bánh mì", calories: 265, protein: 9, carbs: 49, fat: 3.2, saturatedFat: 0.7, sugar: 5, fiber: 2.7, cholesterol: 0, sodium: 491, calcium: 96, iron: 3.6, potassium: 115),
    IngredientNutrition(name: "Rau xà lách", calories: 15, protein: 1.4, carbs: 2.9, fat: 0.2, saturatedFat: 0, sugar: 0.8, fiber: 1.3, cholesterol: 0, sodium: 28, calcium: 36, iron: 0.5, potassium: 194),
    IngredientNutrition(name: "Cà chua", calories: 18, protein: 0.9, carbs: 3.9, fat: 0.2, saturatedFat: 0, sugar: 2.6, fiber: 1.2, cholesterol: 0, sodium: 5, calcium: 10, iron: 0.3, potassium: 237),
    IngredientNutrition(name: "Cà rốt", calories: 41, protein: 0.9, carbs: 10, fat: 0.2, saturatedFat: 0, sugar: 4.7, fiber: 2.8, cholesterol: 0, sodium: 69, calcium: 33, iron: 0.3, potassium: 320),
    IngredientNutrition(name: "Bông cải xanh", calories: 34, protein: 2.8, carbs: 7, fat: 0.4, saturatedFat: 0, sugar: 1.7, fiber: 2.6, cholesterol: 0, sodium: 33, calcium: 47, iron: 0.7, potassium: 316),
    IngredientNutrition(name: "Ớt chuông", calories: 31, protein: 1, carbs: 6, fat: 0.3, saturatedFat: 0, sugar: 4.2, fiber: 2.1, cholesterol: 0, sodium: 2, calcium: 10, iron: 0.3, potassium: 211),
    IngredientNutrition(name: "Hành tây", calories: 40, protein: 1.1, carbs: 9, fat: 0.1, saturatedFat: 0, sugar: 4.2, fiber: 1.7, cholesterol: 0, sodium: 4, calcium: 23, iron: 0.2, potassium: 146),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401),
    IngredientNutrition(name: "Tỏi", calories: 149, protein: 6.4, carbs: 33, fat: 0.5, saturatedFat: 0, sugar: 1, fiber: 2.1, cholesterol: 0, sodium: 17, calcium: 181, iron: 1.7, potassium: 401)
]

