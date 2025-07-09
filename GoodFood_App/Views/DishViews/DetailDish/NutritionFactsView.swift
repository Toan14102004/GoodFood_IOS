//
//  NutritionFactsView.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//

import SwiftUI

struct NutritionFactsView: View {
    let nutrition: NutritionFacts
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(" Kcal: \(Int(nutrition.calories ?? 0))")
                Text(" Protein: \(nutrition.protein ?? 0, specifier: "%.1f")g")
                Text(" Carbs: \(nutrition.carbohydrates ?? 0, specifier: "%.1f")g")
                Text(" saturatedFat: \(nutrition.saturatedFat ?? 0, specifier: "%.1f")g")
                Text(" sugar: \(nutrition.sugar ?? 0, specifier: "%.1f")g")
                Text(" Fat: \(nutrition.fat ?? 0, specifier: "%.1f")g")
                Text(" fiber: \(nutrition.fiber ?? 0, specifier: "%.1f")g")
                Text(" cholesterol: \(nutrition.cholesterol ?? 0, specifier: "%.1f")g")
                Text(" sodium: \(nutrition.sodium ?? 0, specifier: "%.1f")g")
                Text(" calcium: \(nutrition.calcium ?? 0, specifier: "%.1f")g")
                Text(" iron: \(nutrition.iron ?? 0, specifier: "%.1f")g")
                Text(" potassium: \(nutrition.potassium ?? 0, specifier: "%.1f")g")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            LottieView(name: "listIngredient", loopMode: .loop)
                .frame(height: 200)
        }
    }
}
