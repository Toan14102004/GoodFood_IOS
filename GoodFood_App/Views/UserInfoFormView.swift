//
//  UserInfoFormView.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import SwiftUI

struct UserInfoFormView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var age: Int = 20
    @State private var sex: Bool = true
    @State private var height: Double = 1.6
    @State private var weight: Double = 50.0
    @State private var targetWeight: Double = 40.0

    var body: some View {
        Form {
            Section(header: Text("Thông tin cá nhân")) {
                TextField("Tuổi", value: $age, format: .number)
                Toggle("Giới tính (Nam?)", isOn: $sex)
                TextField("Chiều cao (m)", value: $height, format: .number)
                TextField("Cân nặng (kg)", value: $weight, format: .number)
                TextField("Mục tiêu cân nặng (kg)", value: $targetWeight, format: .number)
            }

            Button("Lưu và tiếp tục") {
                if var currentUser = authViewModel.user {
                    currentUser.age = age
                    currentUser.sex = sex
                    currentUser.height = height
                    currentUser.weight = weight
                    currentUser.targetWeight = targetWeight
                    currentUser.weighHistory?.append(weight)
                    authViewModel.user = currentUser
                    authViewModel.showUserInfoForm = false
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Thông tin người dùng")
    }
}
