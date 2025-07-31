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
    @State private var selectedImageName = imageNames.randomElement() ?? "dishSuggest1"

    var body: some View {
        VStack(spacing: 8) {
            self.displayImage

            self.inforCard
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

private extension CardDish {
    var inforCard: some View {
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

    var displayImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 80)

            if let imageName = dish.image {
                if let localImage = loadImageFromDocuments(named: imageName) {
                    Image(uiImage: localImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                } else if let url = URL(string: imageName), imageName.hasPrefix("http") {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                        .cornerRadius(12)
                } else {
                    Image(selectedImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                        .cornerRadius(12)
                }
            } else {
                Image(selectedImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .cornerRadius(12)
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}

struct CardDishOfSuggest: View {
    let dish: Dish
    @State private var selectedImageName = imageNames.randomElement() ?? "dishSuggest1"

    var body: some View {
        VStack(spacing: 8) {
            self.displayImage

            self.inforCard
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .frame(height: 200)
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

private extension CardDishOfSuggest {
    var displayImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 110)

            Image(selectedImageName)
                .resizable()
                .scaledToFill()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .cornerRadius(12)
        }
    }

    var inforCard: some View {
        VStack(spacing: 4) {
            Text(dish.name ?? "Tên món")
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if let dateTime = dish.dateTime {
                Text("Thời gian: \(formattedDate(dateTime))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            } else {
                Text("Thời gian: \(formattedDate(Date()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            if let kcal = dish.nutritionFacts?.calories {
                Text("\(Int(kcal)) kcal")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .frame(width: 50, height: 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                    )
            }
        }
    }
}
