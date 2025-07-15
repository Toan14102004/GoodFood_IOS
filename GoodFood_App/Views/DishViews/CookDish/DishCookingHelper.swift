//
//  DishCookingHelper.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//
import SwiftUI

enum DishCookingHelper {
    static func cookDish(dish: Dish, firebaseService: FirebaseService, presentationMode: Binding<PresentationMode>) {
       
        var newDish = dish
        newDish.id = UUID()
        newDish.dateTime = Date()

        let calories = newDish.nutritionFacts?.calories ?? 0
        let protein = newDish.nutritionFacts?.protein ?? 0
        let carbs = newDish.nutritionFacts?.carbohydrates ?? 0
        let fat = newDish.nutritionFacts?.fat ?? 0

        let nutritionFactsDict: [String: Any]? = {
            guard let facts = newDish.nutritionFacts else { return nil }
            return [
                "calories": facts.calories ?? 0,
                "fat": facts.fat ?? 0,
                "saturatedFat": facts.saturatedFat ?? 0,
                "protein": facts.protein ?? 0,
                "carbohydrates": facts.carbohydrates ?? 0,
                "sugar": facts.sugar ?? 0,
                "fiber": facts.fiber ?? 0,
                "cholesterol": facts.cholesterol ?? 0,
                "sodium": facts.sodium ?? 0,
                "calcium": facts.calcium ?? 0,
                "iron": facts.iron ?? 0,
                "potassium": facts.potassium ?? 0
            ]
        }()

        firebaseService.addDishToToday(
            newDish,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            nutritionFacts: nutritionFactsDict
        ) { result in
            switch result {
            case .success:
                print("Đã lưu món ăn mới thành công!")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Lỗi khi lưu món ăn mới: \(error)")
            }
        }
    }
}
