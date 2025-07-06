//
//  TestDishUploadView.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//
import SwiftUI
import Firebase

struct TestDishUploadView: View {
    @StateObject var firebaseService = FirebaseService()

    var body: some View {
        VStack(spacing: 20) {
            Text("Test Upload Món Ăn")
                .font(.title)
                .bold()

            Button("Gửi món ăn lên Firebase") {
                let dish = Dish(
                    id: UUID(),
                    name: "Salad cá hồi",
                    description: "Giàu protein và ít carb",
                    image: nil,
                    recipe: "Trộn với sốt mè rang",
                    ingredients: [
                        IngredientLite(name: "Cá hồi", unit: "g", state: "nướng", quantity: 100),
                        IngredientLite(name: "Rau xà lách", unit: "g", state: "tươi", quantity: 50)
                    ],
                    nutritionFacts: NutritionFacts(
                        calories: 250,
                        fat: 14,
                        saturatedFat: 2,
                        protein: 25,
                        carbohydrates: 3,
                        sugar: 1,
                        fiber: 2,
                        cholesterol: 50,
                        sodium: 100,
                        calcium: 20,
                        iron: 2,
                        potassium: 300
                    )
                )

                firebaseService.addDishToToday(
                    dish,
                    calories: dish.nutritionFacts?.calories ?? 0,
                    protein: dish.nutritionFacts?.protein ?? 0,
                    carbs: dish.nutritionFacts?.carbohydrates ?? 0,
                    fat: dish.nutritionFacts?.fat ?? 0,
                    nutritionFacts: [
                        "sugar": dish.nutritionFacts?.sugar ?? 0,
                        "fiber": dish.nutritionFacts?.fiber ?? 0,
                        "cholesterol": dish.nutritionFacts?.cholesterol ?? 0,
                        "sodium": dish.nutritionFacts?.sodium ?? 0,
                        "calcium": dish.nutritionFacts?.calcium ?? 0,
                        "iron": dish.nutritionFacts?.iron ?? 0,
                        "potassium": dish.nutritionFacts?.potassium ?? 0
                    ]
                ) { result in
                    switch result {
                    case .success():
                        print("✅ Món ăn đã được thêm vào hôm nay và lịch sử")
                    case .failure(let error):
                        print("❌ Lỗi khi thêm món: \(error.localizedDescription)")
                    }
                }

            }
        }
        .padding()
    }
}

