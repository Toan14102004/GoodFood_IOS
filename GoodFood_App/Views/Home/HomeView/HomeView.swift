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
    @State var KcalIn: Double = 0
    @State var KcalOut: Double = 2000
    @State var Fat: Double = 0
    @State var Carbs: Double = 0
    @State var Protein: Double = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var firebaseService = FirebaseService()

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
            fetchNutritionData(for: selectedDate)
        }
        .onChange(of: selectedDate) { newDate in
            fetchNutritionData(for: newDate)
        }
    }

    func fetchNutritionData(for date: Date) {
        firebaseService.fetchNutritionSummary(for: date) { result in
            switch result {
            case .success(let summary):
                DispatchQueue.main.async {
                    self.KcalIn = summary.calories ?? 0
                    self.Fat = summary.fat ?? 0
                    self.Protein = summary.protein ?? 0
                    self.Carbs = summary.carbohydrates ?? 0
                }
            case .failure(let error):
                print("Lỗi khi lấy dữ liệu tổng ngày: \(error)")
            }
        }
    }
}
