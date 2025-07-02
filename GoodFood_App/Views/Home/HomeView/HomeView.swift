//
//  HomeView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var showButtons = true
    @State var KcalIn: Double = 1789
    @State var KcalOut: Double = 2000
    @State var Fat: Double = 32
    @State var Carbs: Double = 18
    @State var Protein: Double = 23
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HeaderDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)

                        CardUpdateView(showButtons: $showButtons)

                        CardHistoryView(
                            KcalIn: $KcalIn,
                            KcalOut: $KcalOut,
                            Fat: $Fat,
                            Carbs: $Carbs,
                            Protein: $Protein
                        )

                        KcalChartView(data: sampleKcalData)

                        ArticleHealthy()

                        Spacer()
                    }
                    .padding(.horizontal, 2)
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePicker(
                    "Chọn ngày",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let user = authViewModel.user {
                    print(" Thông tin người dùng:")
                    print("ID: \(user.id)")
                    print(" Email: \(user.email)")
                    print(" Tên: \(user.displayName ?? "Không có")")
                    print("👫 Giới tính: \(user.sex == true ? "Nam" : "Nữ")")
                    print(" Chiều cao: \(user.height ?? 0) m")
                    print("⚖️ Cân nặng: \(user.weight ?? 0) kg")
                    print("🎂 Tuổi: \(user.age ?? 0)")
                } else {
                    print("⚠️ Không có người dùng nào đang đăng nhập.")
                }
            }
        }
    }
}
