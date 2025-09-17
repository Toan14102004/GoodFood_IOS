//
//  NutritionFactsView.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//

import SwiftUI

struct NutritionFactsView: View {
    let nutrition: NutritionFacts
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(languageManager.localizedString(" Kcal: \(Int(nutrition.calories ?? 0))"))
                Text(languageManager.localizedString("Protein: \(String(format: "%.1f", nutrition.protein ?? 0)) g"))
                Text(languageManager.localizedString("Carbs: \(String(format: "%.1f", nutrition.carbohydrates ?? 0)) g"))
                Text(languageManager.localizedString("Saturated Fat: \(String(format: "%.1f", nutrition.saturatedFat ?? 0)) g"))
                Text(languageManager.localizedString("Sugar: \(String(format: "%.1f", nutrition.sugar ?? 0)) g"))
                Text(languageManager.localizedString("Fat: \(String(format: "%.1f", nutrition.fat ?? 0)) g"))
                Text(languageManager.localizedString("Fiber: \(String(format: "%.1f", nutrition.fiber ?? 0)) g"))
                Text(languageManager.localizedString("Cholesterol: \(String(format: "%.1f", nutrition.cholesterol ?? 0)) g"))
                Text(languageManager.localizedString("Sodium: \(String(format: "%.1f", nutrition.sodium ?? 0)) g"))
                Text(languageManager.localizedString("Calcium: \(String(format: "%.1f", nutrition.calcium ?? 0)) g"))
                Text(languageManager.localizedString("Iron: \(String(format: "%.1f", nutrition.iron ?? 0)) g"))
                Text(languageManager.localizedString("Potassium: \(String(format: "%.1f", nutrition.potassium ?? 0)) g"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            LottieView(name: "listIngredient", loopMode: .loop)
                .frame(height: 200)
        }
    }
}
