////
////  SplashView.swift
////  GoodFood_App
////
////  Created by Guest User on 20/8/25.
//
//import SwiftUI
//
//struct SplashView: View {
//   
//    @StateObject var authViewModel = AuthViewModel()
//    @EnvironmentObject private var languageManager: LanguageManager
//
//    @StateObject var healthTracker = HealthTracker()
//    @AppStorage(AppStorageKeys.hasSeenOnboarding) private var hasSeenOnboarding: Bool = false
//    @State private var isActive = false
//    
//    var body: some View {
//        ZStack {
//            Color.white.ignoresSafeArea()
//            VStack {
//                LottieView(name: "loadingWelcome", loopMode: .loop)
//                    .frame(width: 300, height: 300)
//                Text(languageManager.localizedString("GoodFood"))
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.green)
//                Text(languageManager.localizedString("Eat Smart, Live Healthy 🌿"))
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.top, 4)
//            }
//            .transition(.opacity)
//        }
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                withAnimation {
//                    isActive = true
//                }
//            }
//        }
////        .fullScreenCover(item: $nextScreen) { screen in
////            switch screen {
////            case .onboarding:
////                OnboardingScreen()
////            case .welcome:
////                WelcomeView()
////                    .environmentObject(healthTracker)
////            }
////        }
//        
//        if isActive {
//                    if !hasSeenOnboarding {
//                        OnboardingScreen()
//                            .environmentObject(languageManager)
//                            .environmentObject(authViewModel)
//                    } else {
//                        WelcomeView()
//                            .environmentObject(languageManager)
//                            .environmentObject(authViewModel)
//                            .environmentObject(healthTracker)
//                    }
//                }
//    }
//}

import SwiftUI

struct SplashView: View {
    @StateObject var authViewModel = AuthViewModel()
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject var healthTracker = HealthTracker()
    
    @AppStorage(AppStorageKeys.hasSeenOnboarding) private var hasSeenOnboarding: Bool = true
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                if !hasSeenOnboarding {
                    OnboardingScreen()
                        .environmentObject(languageManager)
                        .environmentObject(authViewModel)
                } else {
                    WelcomeView()
                        .environmentObject(languageManager)
                        .environmentObject(authViewModel)
                        .environmentObject(healthTracker)
                }
            } else {
                splashContent
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
    
    private var splashContent: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                LottieView(name: "loadingWelcome", loopMode: .loop)
                    .frame(width: 300, height: 300)
                Text(languageManager.localizedString("GoodFood"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text(languageManager.localizedString("Eat Smart, Live Healthy 🌿"))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            .transition(.opacity)
        }
    }
}
