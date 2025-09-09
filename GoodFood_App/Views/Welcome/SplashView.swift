//
//  SplashView.swift
//  GoodFood_App
//
//  Created by Guest User on 20/8/25.
//
import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            OnboardingScreen()
        } else {
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
    
}

