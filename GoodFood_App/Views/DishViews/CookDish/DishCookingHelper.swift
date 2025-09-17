//
//  DishCookingHelper.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//
import SwiftUI

enum DishCookingHelper {
    static func cookDish(dish: Binding<Dish>, firebaseService: FirebaseService, geminiService: GeminiService, presentationMode: Binding<PresentationMode>) {
        var newDish = dish.wrappedValue
        newDish.id = UUID()
        newDish.dateTime = Date()

        // Gửi AI để phân tích dinh dưỡng
        geminiService.analyzeNutrition(for: newDish) { result in
            switch result {
            case .success(let nutritionFacts):
                DispatchQueue.main.async {
                    // Gán kết quả phân tích vào dish chính
                    dish.wrappedValue.nutritionFacts = nutritionFacts

                    // Cập nhật dữ liệu gửi lên Firebase
                    let calories = nutritionFacts.calories ?? 0
                    let protein = nutritionFacts.protein ?? 0
                    let carbs = nutritionFacts.carbohydrates ?? 0
                    let fat = nutritionFacts.fat ?? 0

                    let nutritionFactsDict: [String: Any] = [
                        "calories": nutritionFacts.calories ?? 0,
                        "fat": nutritionFacts.fat ?? 0,
                        "saturatedFat": nutritionFacts.saturatedFat ?? 0,
                        "protein": nutritionFacts.protein ?? 0,
                        "carbohydrates": nutritionFacts.carbohydrates ?? 0,
                        "sugar": nutritionFacts.sugar ?? 0,
                        "fiber": nutritionFacts.fiber ?? 0,
                        "cholesterol": nutritionFacts.cholesterol ?? 0,
                        "sodium": nutritionFacts.sodium ?? 0,
                        "calcium": nutritionFacts.calcium ?? 0,
                        "iron": nutritionFacts.iron ?? 0,
                        "potassium": nutritionFacts.potassium ?? 0
                    ]

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
            case .failure(let error):
                print("Lỗi phân tích dinh dưỡng: \(error.localizedDescription)")
            }
        }
    }
}
