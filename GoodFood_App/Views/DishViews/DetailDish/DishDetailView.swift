//
//  DishDetailView.swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.

import SDWebImageSwiftUI
import SwiftUI

struct DishDetailView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State var dish: Dish
    @StateObject var firebaseService = FirebaseService()
    @State private var isPresentingCookView = false
    @State private var selectedImageName = imageNames.randomElement() ?? "dishSuggest1"
    private let adManager = InterstitialAdManager()
    @State var isCook: Bool = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                DishImageView(imageName: dish.image)

                Text(languageManager.localizedString(dish.name ?? "Tên món"))
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(languageManager.localizedString("Thông tin dinh dưỡng:"))
                    .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                    .bold()
                    .font(.system(size: 20))

                if let nutrition = dish.nutritionFacts {
                    NutritionFactsView(nutrition: nutrition)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(languageManager.localizedString("Danh sách nguyên liệu:"))
                        .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                        .bold()
                        .font(.system(size: 20))

                    IngredientsListView(ingredients: dish.ingredients ?? [])
                }
                .padding(.horizontal)
                if isCook {
                    Button(languageManager.localizedString("Nấu theo")) {
                        isPresentingCookView = true
                        isCook = false

                        if let rootVC = UIApplication.shared
                            .connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .flatMap({ $0.windows })
                            .first(where: { $0.isKeyWindow })?
                            .rootViewController
                        {
                            adManager.onAdDismissed = {
                                isPresentingCookView = true
                                isCook = false
                            }
                            adManager.showAd(from: rootVC)
                        }
                    }
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 144/255, green: 185/255, blue: 78/255))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Chi tiết món ăn")
        .sheet(isPresented: $isPresentingCookView) {
            CookDishView(dish: $dish, isCook: $isCook)
        }
    }
}
