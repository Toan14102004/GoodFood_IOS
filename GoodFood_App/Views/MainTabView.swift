//
//  MainTabView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // nền sáng

        // Màu cho icon & text khi được chọn (selected)
        UITabBar.appearance().tintColor = UIColor(red: 144/255, green: 185/255, blue: 78/255, alpha: 1) // #90B94E

        // Màu cho icon & text khi không được chọn (unselected)
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Trang chủ", systemImage: "house")
                }

            HistoryView()
                .tabItem {
                    Label("Nhật ký", systemImage: "book.closed")
                }

            CameraView()
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 80, height: 80)
                }

//            SuggestView()
//                .tabItem {
//                    Label("Gợi ý món", systemImage: "fork.knife")
//                }
            TestDishUploadView()
                .tabItem {
                    Label("testFirebase", systemImage: "fork.knife")
                }

            ProfileView()
                .tabItem {
                    Label("Cá nhân", systemImage: "person.crop.circle")
                }
        }
        .tint(Color(red: 144/255, green: 185/255, blue: 78/255)) // #90B94E
    }
}

//
// #Preview {
//    MainTabView()
// }
