//
//  DishDetailView.swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.
import SDWebImageSwiftUI
import SwiftUI

struct DishDetailView: View {
    @State var dish: Dish
    @StateObject var firebaseService = FirebaseService()
    @State private var isPresentingCookView = false
    let geminiService = GeminiService.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
//                if let imageURL = dish.image, let url = URL(string: imageURL) {
//                    WebImage(url: url)
//                        .resizable()
//                        .scaledToFit()
//                        .cornerRadius(16)
//                } else {
//                    Image(systemName: "photo.on.rectangle.angled")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 100)
//                        .foregroundColor(.gray)
//                        .cornerRadius(16)
//                }
                
                if let imageName = dish.image {
                    if let localImage = GeminiService.shared.loadImageFromDocuments(named: imageName) {
                        // Ảnh local (đã lưu trong Documents)
                        Image(uiImage: localImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                    } else if let url = URL(string: imageName), imageName.hasPrefix("http") {
                        // Ảnh từ link online
                        WebImage(url: url)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                    } else {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .foregroundColor(.gray)
                            .cornerRadius(16)
                    }
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundColor(.gray)
                        .cornerRadius(16)
                }

                Text(dish.name ?? "Tên món")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("Thông tin dinh dưỡng:")
                    .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                    .bold()
                    .font(.system(size: 20))
                    
                if let nutrition = dish.nutritionFacts {
//                    VStack(alignment: .leading, spacing: 8) {
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Danh sách nguyên liệu:")
                        .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                        .bold()
                        .font(.system(size: 20))
                    
                    ingredientsList()
                }
                .padding(.horizontal)
                
                Button("Nấu theo") {
                    isPresentingCookView = true
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Chi tiết món ăn")
        .sheet(isPresented: $isPresentingCookView) {
            CookDishView(dish: dish)
        }
    }
    
    // Tách riêng Ingredients View vì lỗi compile
    @ViewBuilder
    func ingredientsList() -> some View {
        let ingredients = dish.ingredients ?? []
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
