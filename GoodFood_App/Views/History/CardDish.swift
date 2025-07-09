//
//  CardDish.swift
//  GoodFood_App
//
//  Created by Guest User on 7/7/25.
//
import SDWebImageSwiftUI
import SwiftUI

struct CardDish: View {
    @State var dish: Dish
    let geminiService = GeminiService.shared
    
    var body: some View {
        VStack(spacing: 8) {
            if let imageName = dish.image {
                if let localImage = GeminiService.shared.loadImageFromDocuments(named: imageName) {
                    // Ảnh local lưu trong Documents
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

            VStack(spacing: 4) {
                Text(dish.name ?? "Tên món")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                if let dateTime = dish.dateTime {
                    Text("Thời gian nấu: \(formattedDate(dateTime))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let kcal = dish.nutritionFacts?.calories {
                    Text("\(Int(kcal)) kcal")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
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
