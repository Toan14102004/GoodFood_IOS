//
//  CookDishView .swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.
//
//import SwiftUI
//
//struct CookDishView: View {
//    @State var dish: Dish
//    @StateObject var firebaseService = FirebaseService()
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Chỉnh sửa nguyên liệu")
//                        .font(.title2)
//                        .bold()
//
//                    if let ingredients = dish.ingredients {
//                        ForEach(ingredients.indices, id: \.self) { index in
//                            VStack(alignment: .leading, spacing: 4) {
//                                ingredientEditor(for: index)
//                            }
//                            .padding(.vertical, 4)
//                            Divider()
//                        }
//                    }
//
//                    Button("Lưu vào nhật ký") {
//                        cookDish()
//                    }
//                    .font(.headline)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color(red: 144/255, green: 185/255, blue: 78/255))
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                }
//                .padding()
//            }
//            .navigationTitle("Nấu theo")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Đóng") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//        }
//    }
//
//    // Tách binding nguyên liệu thành hàm riêng (tránh lỗi compile)
//    @ViewBuilder
//    func ingredientEditor(for index: Int) -> some View {
//        if dish.ingredients?.indices.contains(index) == true {
//            let bindingQuantity = Binding<Double>(
//                get: { dish.ingredients?[index].quantity ?? 0 },
//                set: { dish.ingredients?[index].quantity = $0 }
//            )
//
//            HStack {
//                Text(dish.ingredients?[index].name ?? "Nguyên liệu")
//                    .font(.headline)
//
//                Spacer()
//
//                TextField("Số lượng", value: bindingQuantity, formatter: NumberFormatter())
//                    .keyboardType(.decimalPad)
//                    .padding(8)
//                    .frame(width: 80)
//                    .background(Color.white)
//                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
//
//                Text(dish.ingredients?[index].unit ?? "")
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//
//    func cookDish() {
//        let calories = dish.nutritionFacts?.calories ?? 0
//        let protein = dish.nutritionFacts?.protein ?? 0
//        let carbs = dish.nutritionFacts?.carbohydrates ?? 0
//        let fat = dish.nutritionFacts?.fat ?? 0
//
//        let nutritionFactsDict: [String: Any]? = {
//            guard let facts = dish.nutritionFacts else { return nil }
//            return [
//                "calories": facts.calories ?? 0,
//                "fat": facts.fat ?? 0,
//                "saturatedFat": facts.saturatedFat ?? 0,
//                "protein": facts.protein ?? 0,
//                "carbohydrates": facts.carbohydrates ?? 0,
//                "sugar": facts.sugar ?? 0,
//                "fiber": facts.fiber ?? 0,
//                "cholesterol": facts.cholesterol ?? 0,
//                "sodium": facts.sodium ?? 0,
//                "calcium": facts.calcium ?? 0,
//                "iron": facts.iron ?? 0,
//                "potassium": facts.potassium ?? 0
//            ]
//        }()
//
//        firebaseService.addDishToToday(
//            dish,
//            calories: calories,
//            protein: protein,
//            carbs: carbs,
//            fat: fat,
//            nutritionFacts: nutritionFactsDict
//        ) { result in
//            switch result {
//            case .success:
//                print("Đã lưu thành công!")
//                presentationMode.wrappedValue.dismiss()
//            case .failure(let error):
//                print("Lỗi khi lưu món: \(error)")
//            }
//        }
//    }
//}
import SwiftUI

struct CookDishView: View {
    @State var dish: Dish
    @StateObject var firebaseService = FirebaseService()
    @Environment(\.presentationMode) var presentationMode

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
