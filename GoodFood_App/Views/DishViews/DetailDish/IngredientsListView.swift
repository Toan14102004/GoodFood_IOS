//
//  IngredientsListView.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//

import SwiftUI

struct IngredientsListView: View {
    let ingredients: [IngredientLite]
    
    var body: some View {
        ForEach(ingredients.indices, id: \.self) { index in
            VStack(alignment: .leading, spacing: 4) {
                Text("• \(ingredients[index].name ?? "Tên nguyên liệu")")
                    .bold()
                    .foregroundColor(.orange)
                Text("Đơn vị: \(ingredients[index].unit ?? "-")")
                Text("Trạng thái: \(ingredients[index].state ?? "-")")
                Text("Số lượng: \(ingredients[index].quantity ?? 0, specifier: "%.1f")")
            }
            .padding(.vertical, 4)
            Divider()
        }
    }
}
