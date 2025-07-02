//
//  cardInfor.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import SwiftUI

struct CardInfor: View {
    @Binding var title: String
    @Binding var value: String
    var placeholder: String = ""
    var isEditable: Bool = true
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)

            TextField(placeholder, text: $value)
                .disabled(!isEditable)
                .keyboardType(keyboardType)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
        .padding(.horizontal)
    }
}
