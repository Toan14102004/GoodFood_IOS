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
                DishImageView(imageName: dish.image)
                
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
                    NutritionFactsView(nutrition: nutrition)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Danh sách nguyên liệu:")
                        .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                        .bold()
                        .font(.system(size: 20))
                    
                    IngredientsListView(ingredients: dish.ingredients ?? [])
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
}
