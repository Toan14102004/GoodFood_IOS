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
    @State private var kcalIn: Double = 0
    @State private var kcalOut: Double = 2000
    @State private var fat: Double = 0
    @State private var carbs: Double = 0
    @State private var protein: Double = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var firebaseService = FirebaseService()
    @State private var kcalEntries: [KcalEntry] = []
    @State private var showConfirmation = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HeaderDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)

                        CardUpdateView(showButtons: $showButtons)

                        CardHistoryView(kcalIn: $kcalIn, kcalOut: $kcalOut, fat: $fat, carbs: $carbs, protein: $protein)

                        KcalChartView(data: self.kcalEntries)

                        ArticleHealthy()

                        Spacer()
                    }
                    .padding(.horizontal, 2)
                }

                if showDatePicker {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    show_DatePicker

                }
            }
            .alert(self.alertMessage, isPresented: $showConfirmation) {
                Button("OK", role: .cancel) {}
            }
        }
        .onAppear {
            fetchNutritionData(for: self.selectedDate)
            fetchKcalData()
            
            firebaseService.fetchInforUser(authViewModel: authViewModel) { result in
                    switch result {
                    case .success(let fetchedUser):
                        DispatchQueue.main.async {
                            authViewModel.user = fetchedUser
                            let calculatedKcalOut = firebaseService.calculateKcalOut(from: fetchedUser)
                            self.kcalOut = calculatedKcalOut
                            print("✅ KcalOut đã tính từ Firebase: \(calculatedKcalOut)")
                        }
                    case .failure(let error):
                        print("❌ Lỗi khi fetch user từ Firebase: \(error)")
                    }
                }
        }
        .onChange(of: self.selectedDate) { newDate in
            fetchNutritionData(for: newDate)
        }
    }
}




private extension HomeView {
    
    var show_DatePicker : some View {
        VStack {
            Spacer()

            VStack(spacing: 20) {
                DatePicker("Chọn ngày", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding()

                Button("Xác nhận") {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: +1, to: Date())!
                    print("tomorrow : \(tomorrow)")
                    if self.selectedDate > Calendar.current.startOfDay(for: tomorrow) {
                        self.alertMessage = "Chưa có thông tin cho ngày này!"
                    } else {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .long
                        formatter.locale = Locale(identifier: "vi_VN")
                        self.alertMessage = "Ngày đã được chọn : \(formatter.string(from: self.selectedDate))"
                    }
                    showConfirmation = true
                    showDatePicker = false
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Color.primaryGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
            .frame(width: 350)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    func fetchNutritionData(for date: Date) {
        firebaseService.fetchNutritionSummary(for: date) { result in
            switch result {
            case .success(let summary):
                DispatchQueue.main.async {
                    self.kcalIn = summary.calories ?? 0
                    self.fat = summary.fat ?? 0
                    self.protein = summary.protein ?? 0
                    self.carbs = summary.carbohydrates ?? 0
                    
                }
            case .failure(let error):
                print("Lỗi khi lấy dữ liệu tổng ngày: \(error)")
            }
        }
    }

    func fetchKcalData() {
        firebaseService.fetchDailyKcalSummary { result in
            switch result {
            case .success(let entries):
                DispatchQueue.main.async {
                    self.kcalEntries = entries
                }
            case .failure(let error):
                print("Lỗi khi lấy kcal: \(error)")
            }
        }
    }
}
