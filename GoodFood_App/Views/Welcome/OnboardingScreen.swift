//
//  OnboardingScreen.swift
//  GoodFood_App
//
//  Created by Guest User on 20/8/25.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var animate1 = false
    @State private var animate2 = false
    @State private var animate3 = false
    @StateObject var healthTracker = HealthTracker()
    @State private var showWelcome = false
    @State private var nextSceen = false
    
    var body: some View {
        if showWelcome {
            WelcomeView()
                .environmentObject(healthTracker)
        }
        else {
            
            TabView {
                VStack(spacing: 20) {
                    Image(systemName: "leaf.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.green)
                        .scaleEffect(animate1 ? 1.0 : 0.5)
                        .opacity(animate1 ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1)) {
                                animate1 = true
                            }
                        }
                    
                    Text("GoodFood")
                        .font(.title)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                    Text("Ứng dụng giúp bạn theo dõi calo, quản lý dinh dưỡng và ăn uống thông minh hơn mỗi ngày.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    Button(action: {
                        
                        nextSceen = true
                    }) {
                        if nextSceen {
                            VStack(spacing: 20) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(.blue)
                                    .rotationEffect(.degrees(animate2 ? 0 : -180))
                                    .opacity(animate2 ? 1 : 0)
                                    .onAppear {
                                        withAnimation(.spring(response: 1, dampingFraction: 0.6)) {
                                            animate2 = true
                                        }
                                    }
                                Text("Nhận diện món ăn bằng AI")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Chỉ cần chụp ảnh, GoodFood sẽ phân tích nguyên liệu và tính toán dinh dưỡng cho bạn.")
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)                }
                
                VStack(spacing: 20) {
                    Image(systemName: "chart.bar.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.red)
                        .scaleEffect(animate3 ? 1.0 : 0.1)
                        .opacity(animate3 ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 2)) {
                                animate3 = true
                            }
                        }
                    
                    Text("Theo dõi sức khỏe của bạn ❤️")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("GoodFood đồng hành cùng bạn đạt mục tiêu cân nặng và chế độ ăn lành mạnh.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    Button("Bắt đầu ngay") {
                        withAnimation {
                            showWelcome = true
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.vertical, 50)
                
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 0.56, green: 0.73, blue: 0.31), .white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}
