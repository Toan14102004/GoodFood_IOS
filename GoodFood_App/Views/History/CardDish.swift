//
//  CardDish.swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct CardDish: View {
    let dish: Dish
    let geminiService = GeminiService.shared

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 80)

                if let imageName = dish.image {
//                    if let localImage = geminiService.loadImageFromDocuments(named: imageName) {
                    if let localImage = loadImageFromDocuments(named: imageName) {
                        Image(uiImage: localImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .cornerRadius(12)
                    } else if let url = URL(string: imageName), imageName.hasPrefix("http") {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .cornerRadius(12)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                            .foregroundColor(.gray)
                            .cornerRadius(12)
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundColor(.gray)
                        .cornerRadius(12)
                }
            }

            VStack(spacing: 4) {
                Text(dish.name ?? "Tên món")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxHeight: 40)

                if let dateTime = dish.dateTime {
                    Text("Thời gian: \(formattedDate(dateTime))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                if let kcal = dish.nutritionFacts?.calories {
                    Text("\(Int(kcal)) kcal")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
