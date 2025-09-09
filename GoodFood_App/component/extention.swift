//
//  extention.swift
//  GoodFood_App
//
//  Created by Guest User on 4/7/25.
//

//.background(
//    RadialGradient(
//        gradient: Gradient(colors: [Color(red: 0.56, green: 0.73, blue: 0.31).opacity(0.5), // xanh lá nhạt
//                                    .white]),
//        center: .center, // tâm nằm giữa
//        startRadius: 10, // bán kính bắt đầu
//        endRadius: 500 // bán kính kết thúc
//    )
//    .ignoresSafeArea()
//)

import SwiftUI

extension View {
    func dateFormatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    func userInfoTextField(label: String, value: Binding<Double>, keyboardType: UIKeyboardType = .decimalPad) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)

            TextField(label, value: value, format: .number)
                .keyboardType(keyboardType)
                .frame(height: 45)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                )
        }
    }

    func userInfoIntField(label: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
//            Text(languageManager.localizedString(label))
            Text(label)
                .font(.headline)
                .foregroundColor(.black)

            TextField(label, value: value, format: .number)
                .keyboardType(.numberPad)
                .frame(height: 45)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                )
        }
    }

    // Save và Load Image tư Documents
    func saveImageToDocuments(_ image: UIImage, withName name: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = "\(UUID().uuidString).jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)

        do {
            try data.write(to: url)
            return filename // chỉ lưu tên file
        } catch {
            print("Lưu ảnh thất bại: \(error)")
            return nil
        }
    }

    func loadImageFromDocuments(named name: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
        return UIImage(contentsOfFile: url.path)
    }
}
