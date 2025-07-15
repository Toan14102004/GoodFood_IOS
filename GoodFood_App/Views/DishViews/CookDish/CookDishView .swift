//
//  CookDishView .swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.
//

import SwiftUI

struct CookDishView: View {
    @State var dish: Dish
    @StateObject var firebaseService = FirebaseService()
    @Environment(\.presentationMode) var presentationMode
    @State var newIngredients: [String] = []
    @State private var newIngredientName: String = ""
    @State private var newIngredientQuantity: String = ""
    @State private var newIngredientUnit: String = ""


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Chỉnh sửa nguyên liệu")
                        .font(.title2)
                        .bold()

                    if let ingredients = dish.ingredients {
                        ForEach(ingredients.indices, id: \.self) { index in
                            IngredientEditorView(dish: $dish, index: index)
                                .padding(.vertical, 4)
                            Divider()
                        }
                    }
                    
                    Text("Thêm nguyên liệu mới")
                        .font(.title2)
                        .bold()

                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Tên nguyên liệu", text: $newIngredientName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Số lượng", text: $newIngredientQuantity)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Đơn vị", text: $newIngredientUnit)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("Thêm vào danh sách") {
                            addNewIngredient()
                        }
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding(.bottom)

                    if !newIngredients.isEmpty {
                        Text("Nguyên liệu vừa thêm:")
                            .font(.headline)
//
//                        ForEach(newIngredients.indices, id: \.self) { index in
//                            let ing = newIngredients[index]
//                            HStack {
//                                Text("- \(ing.name): \(ing.quantity ?? 0, specifier: "%.1f") \(ing.unit ?? "")")
//                                Spacer()
//                                Button(action: {
//                                    newIngredients.remove(at: index)
//                                }) {
//                                    Image(systemName: "trash")
//                                        .foregroundColor(.red)
//                                }
//                            }
//                        }
                    }

                    

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


extension CookDishView {
    func addNewIngredient() {
        guard !newIngredientName.isEmpty,
              let quantity = Double(newIngredientQuantity),
              !newIngredientUnit.isEmpty else {
            return
        }

        let newIngredient = IngredientLite(
            name: newIngredientName,
            unit: newIngredientUnit,
            state: nil,
            quantity: quantity
        )

       // newIngredients.append(newIngredient)

        newIngredientName = ""
        newIngredientQuantity = ""
        newIngredientUnit = ""
    }
}
