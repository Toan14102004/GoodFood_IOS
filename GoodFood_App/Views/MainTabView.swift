//
//  MainTabView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var firebaseService = FirebaseService()

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // nền sáng

        // Màu cho icon và text khi selected
        UITabBar.appearance().tintColor = UIColor(red: 144/255, green: 185/255, blue: 78/255, alpha: 1) // #90B94E

        // Màu cho icon và text khi unselected
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
        .onAppear {
            if let user = authViewModel.user {
                firebaseService.fetchInforUser(authViewModel: authViewModel) { result in
                    switch result {
                    case .success(let fetchedUser):
                        DispatchQueue.main.async {
                            authViewModel.user = fetchedUser
                            print("fetch user thành công ")
                        }
                    case .failure(let error):
                        print("Lỗi fetch user: \(error)")
                    }
                }
            }
        }
    }
}
