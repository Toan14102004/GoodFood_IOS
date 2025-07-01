//
//  CardUpdateView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct CardUpdateView: View {
    @Binding var showButtons: Bool

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Muốn ăn ngon mà không ăn năn thì vận động đi bạn nhé!")
                    .font(.subheadline)
                    .padding(.bottom, 8)

                if showButtons {
                    HStack(spacing: 12) {
                        NavigationLink {
                            ProfileView()
                        } label: {
                            Text("Cập nhật")
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.primaryGreen)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }

                        Button("Để sau") {
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
