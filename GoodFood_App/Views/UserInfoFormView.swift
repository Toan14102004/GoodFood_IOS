//
//  UserInfoFormView.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

// LanguageSelectionView()
//    .environmentObject(languageManager)
import Firebase
import SwiftUI

struct UserInfoFormView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var firebaseService = FirebaseService()
    @State private var age: Int = 20
    @State private var sex: Bool = true
    @State private var height: Double = 1.6
    @State private var weight: Double = 50.0
    @State private var targetWeight: Double = 40.0
    @State private var weightRecords: WeightRecord = .init()
    @State private var isSelectedLanguage = true

    var body: some View {
        if isSelectedLanguage {
            VStack(spacing: 20) {
                Text(languageManager.localizedString(" Thông Tin Cá Nhân"))
                    .font(.largeTitle.bold())
                    .foregroundColor(Color(red: 144/255, green: 185/255, blue: 78/255))
                    
                Spacer()
                ScrollView {
                    VStack(spacing: 16) {
                        LottieView(name: "iconFormInfor", loopMode: .loop)
                            .frame(width: 200, height: 180)
                            
                        userInfoIntField(label: "Tuổi", value: $age)
                            
                        Toggle(isOn: $sex) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.purple)
                                Text(languageManager.localizedString(sex ? "Giới tính: Nam" : "Giới tính: Nữ"))
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                            
                        userInfoTextField(label: "Chiều cao (m)", value: $height)
                        userInfoTextField(label: "Cân nặng (kg)", value: $weight)
                        userInfoTextField(label: "Mục tiêu cân nặng (kg)", value: $targetWeight)
                    }
                    Spacer()
                        
                    Button(action: {
                        if var currentUser = authViewModel.user {
                            currentUser.age = age
                            currentUser.sex = sex
                            currentUser.height = height
                            currentUser.weight = weight
                            currentUser.targetWeight = targetWeight
                            weightRecords.date = Date()
                            weightRecords.weight = weight
                            currentUser.weighHistory = [weightRecords]
                                
                            authViewModel.user = currentUser
                            authViewModel.showUserInfoForm = false
                                
                            CoreDataService.shared.saveUser(currentUser)
                            firebaseService.saveUserInfoToFirebase(user: currentUser) { result in
                                switch result {
                                case .success():
                                    print(" Đã lưu thông tin người dùng lên Firebase")
                                case .failure(let error):
                                    print(" Lỗi lưu thông tin: \(error.localizedDescription)")
                                }
                            }
                            isSelectedLanguage = false
                        }
                    }) {
                        Text(languageManager.localizedString("Lưu & Tiếp tục"))
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
        }
        else {
            LanguageSelectionView()
                .environmentObject(languageManager)
                .environmentObject(authViewModel)
        }
    }
}
