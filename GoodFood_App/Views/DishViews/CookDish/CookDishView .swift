//
//  CookDishView .swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.
//

import SwiftUI

struct CookDishView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var firebaseService = FirebaseService()

    @Binding var dish: Dish
    @State private var newIngredients: [String] = []
    @State private var newIngredientName: String = ""
    @State private var newIngredientQuantity: String = ""
    @State private var newIngredientUnit: String = "g"
    let availableUnits = ["g", "kg", "ml", "l", "muỗng", "muỗng cà phê", "muỗng canh", "cái", "quả", "miếng", "tép"]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    self.CookTitle("Chỉnh sửa nguyên liệu")

                    self.ListIngeredient

                    self.CookTitle("Thêm nguyên liệu mới")

                    self.addNewIngradients

                    if !newIngredients.isEmpty {
                        Text("Nguyên liệu vừa thêm:")
                            .font(.headline)
                    }

                    buttonSave
                }
                .padding()
            }
            .navigationTitle("Nấu theo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}




private extension CookDishView {
    
    @ViewBuilder
    var ListIngeredient: some View {
        if let ingredients = dish.ingredients {
            ForEach(ingredients.indices,id: \.self) { index in
                IngredientEditorView(dish: $dish, index: index)
                    .padding(.vertical, 4)
                Divider()
            }
        } else {
            Text("aaaa")
        }
    }

    var buttonSave: some View {
        Button("Lưu vào nhật ký") {
            DishCookingHelper.cookDish(dish: dish, firebaseService: firebaseService, presentationMode: presentationMode)
        }
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 144/255, green: 185/255, blue: 78/255))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
    
    var addNewIngradients: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Tên nguyên liệu", text: $newIngredientName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Số lượng", text: $newIngredientQuantity)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                Text( "Đơn vị")
                    .padding(.trailing,24)
                
                Picker("Đơn vị", selection: $newIngredientUnit) {
                    ForEach(availableUnits, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
               
            }
            .padding(.vertical, 4)

            Button("Thêm vào danh sách") {
                addNewIngredient()
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(.bottom)
    }

    func CookTitle(_ title: String) -> some View {
        Text(title)
            .font(.title2)
            .bold()
    }

    func addNewIngredient() {
        guard !newIngredientName.isEmpty,
              let quantity = Double(newIngredientQuantity),
              !newIngredientUnit.isEmpty
        else {
            return
        }

        let newIngredient = IngredientLite(
            name: newIngredientName,
            unit: newIngredientUnit,
            state: nil,
            quantity: quantity
        )

        if dish.ingredients == nil {
            dish.ingredients = []
        }
        dish.ingredients?.append(newIngredient)

        newIngredientName = ""
        newIngredientQuantity = ""
        newIngredientUnit = availableUnits.first ?? "g"
    }

}



