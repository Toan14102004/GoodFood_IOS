//
//  DishImageView.swift
//  GoodFood_App
//
//  Created by Guest User on 9/7/25.
//
import SDWebImageSwiftUI
import SwiftUI

struct DishImageView: View {
    let imageName: String?
    
    var body: some View {
        if let imageName = imageName {
            if let localImage = GeminiService.shared.loadImageFromDocuments(named: imageName) {
                Image(uiImage: localImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
            } else if let url = URL(string: imageName), imageName.hasPrefix("http") {
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
    }
}

