//
//  HeaderDateView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import SwiftUI

struct HeaderDateView: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool

    var body: some View {
        HStack {
            Text(formattedDate)
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            ToolbarButtons(
                onCalendarTap: {
                    showDatePicker.toggle()
                },
                onAddTap: {
                    // Xử lý thêm mục mới
                }
            )
        }
        .padding(.horizontal)
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.dateStyle = .long
        if selectedDate > Calendar.current.startOfDay(for: Date()){
            return formatter.string(from:  Date())
        }
        return formatter.string(from: selectedDate)
    }
}
