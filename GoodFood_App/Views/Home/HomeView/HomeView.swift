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

                        CardHistoryView(KcalIn: $KcalIn, KcalOut: $KcalOut, Fat: $Fat, Carbs: $Carbs, Protein: $Protein)

                        KcalChartView(data: kcalEntries)

                        ArticleHealthy()

                        Spacer()
                    }
                    .padding(.horizontal, 2)
                }

                if showDatePicker {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
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
                                if selectedDate > Calendar.current.startOfDay(for: tomorrow) {
                                    alertMessage = "Chưa có thông tin cho ngày này!"
                                } else {
                                    let formatter = DateFormatter()
                                    formatter.dateStyle = .long
                                    formatter.locale = Locale(identifier: "vi_VN")
                                    alertMessage = "Ngày đã được chọn : \(formatter.string(from: selectedDate))"
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
            }
            .alert(alertMessage, isPresented: $showConfirmation) {
                Button("OK", role: .cancel) {}
            }
        }
        .onAppear {
            fetchNutritionData(for: selectedDate)
            fetchKcalData()
            
            firebaseService.fetchInforUser(authViewModel: authViewModel) { result in
                    switch result {
                    case .success(let fetchedUser):
                        DispatchQueue.main.async {
                            authViewModel.user = fetchedUser
                            let calculatedKcalOut = firebaseService.calculateKcalOut(from: fetchedUser)
                            self.KcalOut = calculatedKcalOut
                            print("✅ KcalOut đã tính từ Firebase: \(calculatedKcalOut)")
                        }
                    case .failure(let error):
                        print("❌ Lỗi khi fetch user từ Firebase: \(error)")
                    }
                }
        }
        .onChange(of: selectedDate) { newDate in
            fetchNutritionData(for: newDate)
        }
    }
}

extension HomeView {
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
