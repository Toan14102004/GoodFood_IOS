//
//  SuggestView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct SuggestView: View {
    @StateObject private var viewModel = SuggestViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 1)
    @State private var selectedImageName = imageNames.randomElement() ?? "dishSuggest1"

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack {
                    Color(red: 144/255, green: 185/255, blue: 78/255)
                        .ignoresSafeArea(edges: .top)

                    Text("Gợi ý món ăn")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                .frame(height: 80)
                Group {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            LottieView(name: "pleaseWait", loopMode: .loop)
                                .frame(width: 200, height: 200)
                            Spacer()
                        }
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack {
                            Spacer()
                            Text("Lỗi: \(errorMessage)")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.dishes, id: \.id) { dish in
                                    NavigationLink(destination: DishDetailView(dish: dish)) {
                                        CardDishOfSuggest(dish: dish)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true) // ẩn thanh điều hướng
        }
        .onAppear {
            viewModel.fetchSuggestions()
        }
    }
}
