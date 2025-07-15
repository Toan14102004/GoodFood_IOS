//
//  SuggestView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct SuggestView: View {
    @StateObject private var viewModel = SuggestViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Đang gợi ý món ăn...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Lỗi: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.dishes, id: \.id) { dish in
                        NavigationLink(destination: DishDetailView(dish: dish)) {
                            VStack(alignment: .leading) {
                                CardDish(dish: dish)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchSuggestions()
            }
            .navigationTitle("Gợi ý món ăn")
        }
    }
}
