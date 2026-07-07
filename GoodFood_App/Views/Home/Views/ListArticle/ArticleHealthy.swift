//
//  ArticleHealthy.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct ArticleHealthy: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject private var viewModel = ArticleViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text(languageManager.localizedString("Bài báo về sức khỏe"))
                .font(.title2)
                .bold()
                .padding([.top, .horizontal])

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            VStack(alignment: .leading, spacing: 8) {
                                if let urlString = article.urlToImage,
                                   let url = URL(string: urlString)
                                {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .padding(.horizontal, 10)
                                                .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                                                .clipped()
                                                .cornerRadius(10)

                                        default:
                                            Color.gray.opacity(0.2)
                                                .frame(height: 180)
                                                .cornerRadius(10)
                                        }
                                    }
                                }

                                Text(languageManager.localizedString(article.title))
                                    .font(.headline)

                                Text(languageManager.localizedString(article.description ?? ""))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 16)
                        }
                        .buttonStyle(PlainButtonStyle()) // Xoá hiệu ứng màu xanh của NavigationLink
                        
                        VStack {
                            NativeAdSwiftUIView()
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 16)
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

struct CardArticle: View {
    var article: Article
    var body: some View {
        VStack {}
    }
}
