//
//  DishCookingHelper.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//

import SwiftUI

enum DishCookingHelper {
    static func cookDish(dish: Dish, firebaseService: FirebaseService, presentationMode: Binding<PresentationMode>) {
        let calories = dish.nutritionFacts?.calories ?? 0
        let protein = dish.nutritionFacts?.protein ?? 0
        let carbs = dish.nutritionFacts?.carbohydrates ?? 0
        let fat = dish.nutritionFacts?.fat ?? 0

        let nutritionFactsDict: [String: Any]? = {
            guard let facts = dish.nutritionFacts else { return nil }
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
            dish,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fat: fat,
            nutritionFacts: nutritionFactsDict
        ) { result in
            switch result {
            case .success:
                print("Đã lưu thành công!")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Lỗi khi lưu món: \(error)")
            }
        }
    }
}
