//
//  HelpView.swift
//  GoodFood_App
//
//  Created by Guest User on 5/9/25.
//
import SwiftUI

struct HelpView: View {
    @EnvironmentObject var userData: AuthViewModel
    @State private var inputQuestion: String = ""
    @State private var revealDetails = false
    @State private var expandedIndex: Int? = nil

    let items: [(title: String, icon: String)] = [
        ("Báo cáo sự cố", "exclamationmark.triangle.fill"),
        ("Yêu cầu tính năng mới", "lightbulb.fill")
    ]
    
    var body: some View {
        VStack {
            header
            listFeature
            listQuestions
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 144/255, green: 185/255, blue: 135/255).opacity(0.2))
    }
}

extension HelpView {
    var header: some View {
        HStack {
            VStack(alignment: .leading) {
                if let user = userData.user {
                    Text("Xin chào, \(user.displayName ?? "User") !")
                        .font(.headline)
                } else {
                    Text("Xin chào, User !")
                }
                Text("Bạn cần trợ giúp về điều gì nào?")
                    .padding(.top, 2)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)

            }
            .padding(.leading, 10)
            
            Spacer()
            
            VStack {
                LottieView(name: "Chatbit", loopMode: .loop)
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    var listFeature: some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                NavigationLink {
                    Text("Màn hình \(items[index].title)")
                    Button("Test Crash") {
                                fatalError("Crashlytics test crash")
                            }
                } label: {
                    HStack {
                        Image(systemName: items[index].icon)
                            .foregroundColor(.yellow)
                        Text(items[index].title)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255).opacity(2.0))
                    }
                    .padding()
                }
                
                if index < items.count - 1 {
                    Divider()
                }
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
    
    var listQuestions: some View {
        VStack(spacing: 0) {
            TextField(" Nhập từ khoá hoặc câu hỏi cần tìm kiếm", text: $inputQuestion)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                )
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
            ScrollView {
                ForEach(questions.indices, id: \.self) { index in
                    DisclosureGroup(
                        isExpanded: Binding(
                            get: { expandedIndex == index },
                            set: { isExpanded in
                                expandedIndex = isExpanded ? index : nil
                            }
                        )
                    ) {
                        Text(questions[index].ask)
                            .padding(.top, 5)
                    } label: {
                        Text(questions[index].question)
                            .font(.headline)
                    }
                    .padding(.horizontal, 10)
                    
                    if index < questions.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}
