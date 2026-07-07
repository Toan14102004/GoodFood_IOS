//
//  CardUpdateView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import GoogleMobileAds
import SwiftUI

struct CardUpdateView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var showButtons: Bool
    @StateObject private var interstitial = InterstitialAdManager()
    @State private var localizedText = "Muốn ăn ngon mà không ăn năn thì vận động đi bạn nhé!"

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(languageManager.localizedString("Muốn ăn ngon mà không ăn năn thì vận động đi bạn nhé!"))
                    .font(.subheadline)
                    .padding(.bottom, 8)
//                TypewriterTextView(fullText: languageManager.localizedString(localizedText))


                if showButtons {
                    HStack(spacing: 12) {
                        NavigationLink {
                            ProfileView()
                        } label: {
                            Text(languageManager.localizedString("Cập nhật"))
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.primaryGreen)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }

                        Button(languageManager.localizedString("Để sau")) {
                            showButtons = false
                        }
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.gray)
                        .cornerRadius(16)
                    }
                }
            }
            .onAppear {
                localizedText = languageManager.localizedString(localizedText)
            }

            Spacer()

            LottieView(name: "vegetable", loopMode: .loop)
                .frame(width: 120, height: 120)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
        .padding(.top)
    }
}

