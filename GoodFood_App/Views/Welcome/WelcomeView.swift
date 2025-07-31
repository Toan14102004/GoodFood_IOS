//
//  WelcomeView.swift
//  Good_Food
//
//  Created by Guest User on 30/6/25.
//
import Firebase
import GoogleSignIn
import SwiftUI

struct WelcomeView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State var age: Int = 20
    @State var sex: Bool = true
    @State var height: Double = 1.55
    @State var weight: Double = 43.8
    @State var target: Double = 42.0
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                ZStack {
                    Color.white.ignoresSafeArea()
                    LottieView(name: "loadingWelcome", loopMode: .loop)
                        .frame(width: 300, height: 300)
                }
            }
            else {
                if authViewModel.isLoggedIn {
                    if authViewModel.showUserInfoForm {
                        UserInfoFormView()
                            .environmentObject(authViewModel)
                        
                    } else {
                        MainTabView()
                            .environmentObject(authViewModel)
                    }
                } else {
                    ZStack {
                        Image("AssetHome")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        VStack {
                            NavigationStack {
                                VStack(spacing: 30) {
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text("Good-Food")
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                                .padding(.top, 50)
                                                .overlay(
                                                    LinearGradient(
                                                        colors: [.green, .blue],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .mask(
                                                    Text("Good-Food")
                                                        .font(.largeTitle)
                                                        .fontWeight(.bold)
                                                        .padding(.top, 50)
                                                )
                                            
                                            Image(systemName: "leaf.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(.green.opacity(0.9))
                                                .padding(.top, 40)
                                        }
                                        
                                        Text("Ăn uống thông minh – sống khoẻ mỗi ngày 🌿")
                                            .font(.subheadline)
                                            .foregroundColor(.green.opacity(0.8))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                            .mask(
                                                Text("Ăn uống thông minh – sống khoẻ mỗi ngày 🌿")
                                                    .font(.subheadline)
                                                    .multilineTextAlignment(.center)
                                            )
                                    }
                                    
                                    LottieView(name: "iconWelcome", loopMode: .loop)
                                        .frame(width: 400, height: 380)

                                    Spacer()
                                    
                                    Button(action: {
                                        authViewModel.signInWithGoogle()
                                    }) {
                                        HStack {
                                            Image(systemName: "globe")
                                            Text("Đăng nhập bằng Google")
                                        }
                                        .font(.headline)
                                        .padding()
                                        .frame(width: 300)
                                        .background(Color.white.opacity(0.9))
                                        .foregroundColor(.green)
                                        .shadow(radius: 4)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                                        )
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                authViewModel.checkIfLoggedIn()
                isLoading = false
            }
        }
    }
}

// LottieView(name: "loadingWelcome", loopMode: .loop")
