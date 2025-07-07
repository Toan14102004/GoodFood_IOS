//
//  HistoryView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import SwiftUI

struct HistoryView: View {
    @State private var dishes: [Dish] = []
    @StateObject var firebaseService = FirebaseService()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(dishes, id: \.id) { dish in
                        NavigationLink(destination: DishDetailView(dish: dish)) {
                            CardDish(dish: dish)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Lịch sử món ăn")
            .onAppear {
                print("Đã vào trang lịch sử rồi nhé ")
                fetchHistory()
            }
        }
    }

    func fetchHistory() {
        firebaseService.fetchDishHistory { result in
            switch result {
            case .success(let fetchedDishes):
                self.dishes = fetchedDishes.sorted(by: { ($0.dateTime ?? Date()) > ($1.dateTime ?? Date()) })
            case .failure(let error):
                print("Lỗi khi lấy danh sách món ăn: \(error)")
            }
        }
    }
}
