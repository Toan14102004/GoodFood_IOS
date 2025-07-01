//
//  ArticleHealthy.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct ArticleHealthy: View {
    @StateObject private var viewModel = ArticleViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text(" Bài báo về sức khỏe")
                .font(.title2)
                .bold()
                .padding([.top, .horizontal])

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            VStack(alignment: .leading, spacing: 8) {
                                if let urlString = article.urlToImage,
                                   let url = URL(string: urlString) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 180)
                                                .clipped()
                                                .cornerRadius(10)
                                        default:
                                            Color.gray.opacity(0.2)
                                                .frame(height: 180)
                                                .cornerRadius(10)
                                        }
                                    }
                                }

                                Text(article.title)
                                    .font(.headline)

                                Text(article.description ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle()) // Xoá hiệu ứng màu xanh của NavigationLink
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            viewModel.fetchArticles()
        }
    }
}
