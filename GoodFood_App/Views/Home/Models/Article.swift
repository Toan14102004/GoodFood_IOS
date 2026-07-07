//
//  Article.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String?
    let content: String?
    let urlToImage: String?
    let url: String?
}
