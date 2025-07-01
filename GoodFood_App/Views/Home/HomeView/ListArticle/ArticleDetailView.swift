//
//  ArticleDetailView.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = article.urlToImage,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .clipped()
                        default:
                            Color.gray.opacity(0.2)
                                .frame(height: 220)
                        }
                    }
                }

                Text(article.title)
                    .font(.title)
                    .bold()

                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                if let content = article.content {
                    Text(content)
                        .font(.body)
                        .padding(.top)
                }

                if let urlString = article.url,
                   let url = URL(string: urlString) {
                    Link("Xem bài gốc", destination: url)
                        .foregroundColor(.blue)
                        .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle("Chi tiết")
        .navigationBarTitleDisplayMode(.inline)
    }
}
