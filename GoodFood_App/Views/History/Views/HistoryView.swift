//
//  HistoryView.swift
//  GoodFood_App
// path : reset điều hướng mỗi khi .onAppear được gọi
//  Created by Guest User on 30/6/25.
//

// if dishes.isEmpty {
//        VStack {
//            LottieView(name: "loadingWelcome", loopMode: .loop)
//                .frame(width: 300, height: 300)
//                .padding(.top, 50)
//
//            Text("Chưa có món ăn nào")
//                .font(.title3)
//                .foregroundColor(.gray)
//        }
//        .frame(maxWidth: .infinity, minHeight: 400)

import GoogleMobileAds
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject private var rewardedAd = RewardedAdManager()
    @State private var dishes: [Dish] = []
    @StateObject var firebaseService = FirebaseService()
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    VStack {
                        Text(languageManager.localizedString("Lịch sử món ăn"))
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 80)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 144/255, green: 185/255, blue: 78/255))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)

                    ScrollView {
                        if dishes.isEmpty {
                            VStack {
                                LottieView(name: "FoodHistory", loopMode: .loop)
                                    .frame(width: 300, height: 300)
                                    .padding(.top, 50)

                                Text(languageManager.localizedString("Chưa có món ăn nào"))
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 400)
                        }
                        else {
                            VStack(alignment: .leading, spacing: 24) {
                                if !todayDishes.isEmpty {
                                    Section(header: Text(languageManager.localizedString("Hôm nay"))
                                        .font(.title3)
                                        .bold()
                                        .padding(.horizontal))
                                    {
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
                                    Section(header: Text(languageManager.localizedString("Hôm qua"))
                                        .font(.title3)
                                        .bold()
                                        .padding(.horizontal))
                                    {
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
                                    Section(header: Text(languageManager.localizedString("Trước đó"))
                                        .font(.title3)
                                        .bold()
                                        .padding(.horizontal))
                                    {
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
                            .padding(.top, 16)
                        }
                    }
                }
                .ignoresSafeArea(edges: .top) // cho header ăn lên phần notch
                .onAppear {
                    path = NavigationPath()
                    fetchHistory()
                }
                Button(action: {
                    if let root = UIApplication.shared.windows.first?.rootViewController {
                        rewardedAd.showRewardedAd(from: root) { reward in
                            print("Người dùng nhận thưởng: \(reward.amount) \(reward.type)")
                        }
                    }
                }) {
                    LottieView(name: "ReferralGift", loopMode: .loop)
                        .frame(width: 65, height: 80)
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                }
                .disabled(!rewardedAd.isReady)
            }
        }
    }
}

extension HistoryView {
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
