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
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var path = NavigationPath()

    
    var todayDishes: [Dish] {
        dishes.filter { isSameDay($0.dateTime, Date()) }
    }

    var yesterdayDishes: [Dish] {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return dishes.filter { isSameDay($0.dateTime, yesterday) }
    }

    var earlierDishes: [Dish] {
        dishes.filter {
            guard let date = $0.dateTime else { return false }
            return !isSameDay(date, Date()) && !isSameDay(date, Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if !todayDishes.isEmpty {
                        Section(header: Text("Hôm nay")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal)) {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(todayDishes, id: \.id) { dish in
                                    NavigationLink(destination: DishDetailView(dish: dish)) {
                                        CardDish(dish: dish)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    if !yesterdayDishes.isEmpty {
                        Section(header: Text("Hôm qua")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal)) {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(yesterdayDishes, id: \.id) { dish in
                                    NavigationLink(destination: DishDetailView(dish: dish)) {
                                        CardDish(dish: dish)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    if !earlierDishes.isEmpty {
                        Section(header: Text("Trước đó")
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal)) {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(earlierDishes, id: \.id) { dish in
                                    NavigationLink(destination: DishDetailView(dish: dish)) {
                                        CardDish(dish: dish)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Lịch sử món ăn")
            .onAppear {
                path = NavigationPath()
                fetchHistory()
            }
        }
    }

    func isSameDay(_ date1: Date?, _ date2: Date?) -> Bool {
        guard let d1 = date1, let d2 = date2 else { return false }
        return Calendar.current.isDate(d1, inSameDayAs: d2)
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
