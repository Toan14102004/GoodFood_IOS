//
//  SuggestView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct SuggestView: View {
    @StateObject private var viewModel = SuggestViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var selectedImageName = imageNames.randomElement() ?? "dishSuggest1"
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
//                    ProgressView("Đang gợi ý món ăn...")
                    LottieView(name: "pleaseWait",loopMode: .loop)
                        .frame(width: 200,height: 200)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Lỗi: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.dishes, id: \.id) { dish in
                        VStack {
                            CardDishOfSuggest(dish: dish)
                        }
                        .padding(.vertical)
                        .background(
                            NavigationLink(destination: DishDetailView(dish: dish)) {}
                                .buttonStyle(PlainButtonStyle())
                        )
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
