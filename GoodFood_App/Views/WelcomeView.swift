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
    
    var body: some View {
        Group {
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
                                
                                Image(systemName: "leaf.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.green.opacity(0.9))
                                    .padding()
                                
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
                                    .cornerRadius(16)
                                    .shadow(radius: 4)
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            authViewModel.checkIfLoggedIn()
        }
    }
}
