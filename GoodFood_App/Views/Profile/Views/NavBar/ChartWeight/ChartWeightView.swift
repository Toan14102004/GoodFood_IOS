//
//  ChartWeightView.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Charts
import SwiftUI

struct ChartWeightRecord: Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
}

struct ChartWeightView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State var data: [ChartWeightRecord] = []
   

    var body: some View {

        VStack {
            if data.count < 2 {
                LottieView(name: "currentNoData", loopMode: .loop)
                    .frame(height: 350)
                    .padding()
            }
            else {
                
                LottieView(name: "weightsLift", loopMode: .loop)
                    .frame(height: 150)
                    .padding()

                Chart {
                    ForEach(data) { entry in
                        AreaMark(
                            x: .value("Ngày", entry.date),
                            y: .value("Kcal", entry.weight)
                        )
                        .foregroundStyle(Color.primaryGreen.opacity(0.3))
                    }

                    ForEach(data) { entry in
                        LineMark(
                            x: .value("Date", entry.date),
                            y: .value("Weight", entry.weight)
                        )
                        .foregroundStyle(Color.primaryGreen)
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(languageManager.localizedString(date.formatted(.dateTime.hour().minute())))
                            }
                        }
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }

            Text(languageManager.localizedString("Biểu đồ cân nặng"))
                .font(.headline)
                .bold()
                .font(.system(size: 20))
        }
        .onAppear {
            DispatchQueue.main.async {
                let originalData = getWeightHistory()
                self.data = originalData.map { ChartWeightRecord(date: $0.date, weight: $0.weight) }
            }
        }
    }
}

extension ChartWeightView {
    private func getWeightHistory() -> [WeightRecord] {
        let (_, weightHistory) = CoreDataService.shared.fetchUser()
        guard let weightHistory = weightHistory else {
            print("vì saooo")
            print("Không có lịch sử cân nặng.")
            return []
        }
        for record in weightHistory {
            print("Ngày: \(record.date), Cân nặng: \(record.weight)")
        }
        print("Số lượng dữ liệu cân nặng: \(weightHistory.count)")
        return weightHistory
    }
}
