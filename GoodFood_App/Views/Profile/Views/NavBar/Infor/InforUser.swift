//
//  InforUser.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import SwiftUI

struct InforUser: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject var firebaseService = FirebaseService()
    @State private var name: String = ""
    @State private var age: String = "20"
    @State private var sex: Bool = true
    @State private var height: String = "1.60"
    @State private var weight: String = "50"
    @State var showAlertSuccess: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State var weightHistory: WeightRecord?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(languageManager.localizedString("Cập nhật thông tin"))
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)

                LottieView(name: languageManager.localizedString("updateProfile"), loopMode: .loop)
                    .padding(.bottom, 16)
                    .frame(width: 150, height: 150)
                CardInfor(title: .constant(languageManager.localizedString("Tên")), value: $name, placeholder: languageManager.localizedString("Nhập tên"))
                CardInfor(title: .constant(languageManager.localizedString("Tuổi")), value: $age, placeholder: languageManager.localizedString("Nhập tuổi"), keyboardType: .numberPad)

                toggleSex

                CardInfor(title: .constant(languageManager.localizedString("Chiều cao (m)")), value: $height, placeholder: "VD: 1.65", keyboardType: .decimalPad)
                CardInfor(title: .constant(languageManager.localizedString("Cân nặng (kg)")), value: $weight, placeholder: "VD: 55", keyboardType: .decimalPad)

                buttonUpdate
            }
            .onAppear {
//                if CoreDataService.shared.hasUserInCoreData() {
//                    loadUser()
//                } else {
//                    print("Chưa có user trong CoreData")
//                }
                ensureUserData(authViewModel: authViewModel)
                //CoreDataService.shared.fetchUser()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { showAlertSuccess || showErrorAlert },
            set: { _ in
                showAlertSuccess = false
                showErrorAlert = false
            }
        )) {
            if showAlertSuccess {
                return Alert(
                    title: Text(languageManager.localizedString("Thành công")),
                    message: Text(languageManager.localizedString("Cập nhật thông tin thành công!")),
                    dismissButton: .default(Text(languageManager.localizedString("OK")))
                )
            } else {
                return Alert(
                    title: Text(languageManager.localizedString("Lỗi")),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

private extension InforUser {
    var buttonUpdate: some View {
        Button(languageManager.localizedString("Cập nhật")) {
            updateUserInfo()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.primaryGreen)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.horizontal)
    }

    var toggleSex: some View {
        Toggle(isOn: $sex) {
            Text(languageManager.localizedString("Giới tính: \(sex ? "Nam" : "Nữ")"))
                .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
        .padding(.horizontal)
    }

    func loadUser() {
        guard let user = CoreDataService.shared.fetchUserModel() else { return }
        name = user.displayName ?? ""
        age = "\(user.age ?? 20)"
        sex = user.sex ?? true
        height = String(format: "%.2f", user.height ?? 1.6)
        weight = String(format: "%.1f", user.weight ?? 50.0)
    }
    
    func ensureUserData(authViewModel: AuthViewModel) {
        // 1. Nếu CoreData đã có user thì gán vào authViewModel luôn
        if let localUser = CoreDataService.shared.fetchUserModel() {
            print(" User đã có trong CoreData")
            DispatchQueue.main.async {
                authViewModel.user = localUser
                loadUser() // update UI
            }
            return
        }

        // Nếu chưa có -> fetch từ Firebase
        firebaseService.fetchInforUser(authViewModel: authViewModel) { result in
            switch result {
            case .success(let user):
                CoreDataService.shared.saveUser(user)

                DispatchQueue.main.async {
                    authViewModel.user = user
                    loadUser()
                }
                print("Đã fetch user từ Firebase và lưu vào CoreData")

            case .failure(let error):
                print("Lỗi khi fetch user từ Firebase: \(error.localizedDescription)")
            }
        }
    }


    func updateUserInfo() {
        guard let ageInt = Int(age), ageInt > 0 else {
            errorMessage = "Tuổi không hợp lệ. Vui lòng nhập số ≥ 0."
            showErrorAlert = true
            return
        }

        // parse cân nặng có dấu phẩy
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.decimalSeparator = ","

        var weightDouble: Double?
        if let number = formatter.number(from: weight) {
            weightDouble = number.doubleValue
        } else if let number = Double(weight.replacingOccurrences(of: ",", with: ".")) {
            // fallback: nếu user nhập có dấu . thì vẫn được
            weightDouble = number
        }

        guard let finalWeight = weightDouble, finalWeight > 0 else {
            errorMessage = "Cân nặng \(weight) không hợp lệ. Vui lòng nhập số ≥ 0."
            showErrorAlert = true
            return
        }

        guard var user = CoreDataService.shared.fetchUserModel() else { return }

        user.displayName = name
        user.sex = sex
        user.age = ageInt

        // parse chiều cao
        let heightFormatter = NumberFormatter()
        heightFormatter.locale = Locale(identifier: "vi_VN")
        heightFormatter.decimalSeparator = ","

        var heightDouble: Double?
        if let number = heightFormatter.number(from: height) {
            heightDouble = number.doubleValue
        } else if let number = Double(height.replacingOccurrences(of: ",", with: ".")) {
            heightDouble = number
        }

        user.height = heightDouble ?? 1.6
        user.weight = finalWeight
        weightHistory = WeightRecord(weight: finalWeight)

        if user.weighHistory != nil {
            user.weighHistory?.append(weightHistory ?? WeightRecord())
        } else {
            user.weighHistory = [weightHistory ?? WeightRecord()]
        }

        authViewModel.user = user

        CoreDataService.shared.updateUserInforToCoredata(
            user,
            name,
            Int32(ageInt),
            sex,
            user.height ?? 1.6,
            finalWeight
        )
        showAlertSuccess = true

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
