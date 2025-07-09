//
//  ingredientEditor.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//
import SwiftUI

struct IngredientEditorView: View {
    @Binding var dish: Dish
    let index: Int

    var body: some View {
        if dish.ingredients?.indices.contains(index) == true {
            let bindingQuantity = Binding<Double>(
                get: { dish.ingredients?[index].quantity ?? 0 },
                set: { dish.ingredients?[index].quantity = $0 }
            )

            HStack {
                Text(dish.ingredients?[index].name ?? "Nguyên liệu")
                    .font(.headline)

                Spacer()

                TextField("Số lượng", value: bindingQuantity, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding(8)
                    .frame(width: 80)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                Text(dish.ingredients?[index].unit ?? "")
                    .foregroundColor(.gray)
            }
        }
    }
}
