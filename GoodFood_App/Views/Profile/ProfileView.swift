//
//  ProfileView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            if let user = authViewModel.user {
                if let photoURL = user.photoURL, let url = URL(string: photoURL) {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color(red: 144/255, green: 185/255, blue: 78/255)
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 4)
                        )

                        LogoutButton {
                            authViewModel.signOut()
                        }
                    }
                }

                Text(user.email)
                    .foregroundColor(Color.gray.opacity(0.9))
                if let name = user.displayName {
                    Text(name)
                        .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                        .bold()
                }

                Divider()
                    .frame(height: 2)
                    .background(Color.gray.opacity(0.3))
                    .padding(.horizontal)

                NavBarView()

                Spacer()
            } else {
                Text("Chưa đăng nhập")
            }
        }
    }
}
