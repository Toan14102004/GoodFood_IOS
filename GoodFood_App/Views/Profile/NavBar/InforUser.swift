//
//  InforUser.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import SwiftUI

struct InforUser: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var firebaseService = FirebaseService()

    @State private var name: String = ""
    @State private var age: String = "20"
    @State private var sex: Bool = true
    @State private var height: String = "1.60"
    @State private var weight: String = "50"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Cập nhật thông tin")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)

                CardInfor(title: .constant("Tên"), value: $name, placeholder: "Nhập tên")
                CardInfor(title: .constant("Tuổi"), value: $age, placeholder: "Nhập tuổi", keyboardType: .numberPad)

                Toggle(isOn: $sex) {
                    Text("Giới tính: \(sex ? "Nam" : "Nữ")")
                        .font(.headline)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
                .padding(.horizontal)

                CardInfor(title: .constant("Chiều cao (m)"), value: $height, placeholder: "VD: 1.65", keyboardType: .decimalPad)
                CardInfor(title: .constant("Cân nặng (kg)"), value: $weight, placeholder: "VD: 55", keyboardType: .decimalPad)

                Button("Cập nhật") {
                    updateUserInfo()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primaryGreen)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .onAppear {
                loadUser()
            }
        }
    }

    private func loadUser() {
        guard let user = authViewModel.user else { return }
        name = user.displayName ?? ""
        age = "\(user.age ?? 20)"
        sex = user.sex ?? true
        height = String(format: "%.2f", user.height ?? 1.6)
        weight = String(format: "%.1f", user.weight ?? 50.0)
    }

    private func updateUserInfo() {
        guard var user = authViewModel.user else { return }
        user.displayName = name
        user.age = Int(age) ?? 20
        user.sex = sex
        user.height = Double(height) ?? 1.6
        user.weight = Double(weight) ?? 50.0
        authViewModel.user = user
       // CoreDataService.shared.updateUserInforToFirebase(user)
        firebaseService.updateUserInforToFirebase(user) { result in
            switch result {
            case .success():
                print(" Đã lưu thông tin người dùng lên Firebase")
            case .failure(let error):
                print(" Lỗi lưu thông tin: \(error.localizedDescription)")
            }
        }
    }
}
