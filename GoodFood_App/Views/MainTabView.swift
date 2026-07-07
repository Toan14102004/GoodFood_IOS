//
//  MainTabView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject var firebaseService = FirebaseService()
    @State private var KcalOut: Double = 2000

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        // Màu cho icon và text khi selected
        UITabBar.appearance().tintColor = UIColor(red: 144/255, green: 185/255, blue: 78/255, alpha: 1)

        // Màu cho icon và text khi unselected
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label(languageManager.localizedString("Trang chủ"), systemImage: "house")
                }

            HistoryView()
                .tabItem {
                    Label(languageManager.localizedString("Nhật ký"), systemImage: "book.closed")
                }

            CameraView()
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 80, height: 80)
                }

            SuggestView()
                .tabItem {
                    Label(languageManager.localizedString("Gợi ý món"), systemImage: "fork.knife")
                }

            ProfileView()
                .tabItem {
                    Label(languageManager.localizedString("Cá nhân"), systemImage: "person.crop.circle")
                }
        }
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
