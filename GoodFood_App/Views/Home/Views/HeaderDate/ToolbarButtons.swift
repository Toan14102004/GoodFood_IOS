//
//  ToolbarButtons.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct ToolbarButtons: View {
    @EnvironmentObject var languageManager: LanguageManager
    var onCalendarTap: () -> Void
    @State private var showLanguageSelection = false

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onCalendarTap) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            NavigationLink(destination: HelpView()) {
                Image(systemName: "questionmark.circle")
                    .font(.title2)
                    .foregroundColor(.black)
            }

//            NavigationLink(destination: LanguageSelectionView()
//                .navigationBarBackButtonHidden(true)
//            ) {
//                Text(languageManager.selectedLanguage)
//                    .font(.title2)
//                    .foregroundColor(.black)
//            }
            Button(action: {
                            showLanguageSelection = true
                        }) {
                            Text(languageManager.selectedLanguage)
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .fullScreenCover(isPresented: $showLanguageSelection) {
                            LanguageSelectionView()
                                .environmentObject(languageManager)
                                .ignoresSafeArea() // chiếm full màn hình -> che navbar
                        }
            
        }
    }
}
