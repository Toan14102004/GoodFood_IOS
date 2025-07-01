//
//  ArticleViewModel.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []

    func fetchArticles() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?category=health&country=us&apiKey=439e9cb051f84ad68e694370e90eeeb3") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.articles = response.articles
                }
            } catch {
                print("Decode error:", error)
            }
        }.resume()
    }
}

