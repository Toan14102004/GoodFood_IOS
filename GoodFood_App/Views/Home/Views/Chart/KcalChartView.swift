//
//  KcalChartView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

//                Chart {
//                    ForEach(data) { entry in
//                        LineMark(
//                            x: .value("Ngày", entry.date),
//                            y: .value("Kcal", entry.kcal)
//                        )
//                        .foregroundStyle(Color.primaryGreen)
//                        .symbol(Circle()) // Thêm chấm tròn tại mỗi điểm nếu thích
//                    }
//                }

import Charts
import SwiftUI

struct KcalChartView: View {
    let data: [KcalEntry]

    var last7DaysData: [KcalEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (0..<7).map { offset in
            let day = calendar.date(byAdding: .day, value: -offset, to: today)!
            let entry = data.first { calendar.isDate($0.date, inSameDayAs: day) }
            return entry ?? KcalEntry(date: day, kcal: 0)
        }
        .reversed() // để hôm cũ bên trái, hôm mới bên phải
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Kcal trong 7 ngày")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 16)
                .padding(.horizontal)

            VStack {
                Chart {
                    ForEach(last7DaysData) { entry in
                        BarMark(
                            x: .value("Ngày", entry.date, unit: .day),
                            y: .value("Kcal", entry.kcal)
                        )
                        .foregroundStyle(Color.primaryGreen)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month())
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)

                Text("Biểu đồ Kcal In cho 7 ngày gần nhất")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal)

        }
        .padding(.top)
    }
}

//import Charts
//import SwiftUI
//
//struct KcalChartView: View {
//    let data: [KcalEntry]
//    @State private var animatedData: [KcalEntry] = []
//
//    var last7DaysData: [KcalEntry] {
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//
//        return (0..<7).map { offset in
//            let day = calendar.date(byAdding: .day, value: -offset, to: today)!
//            let entry = data.first { calendar.isDate($0.date, inSameDayAs: day) }
//            return entry ?? KcalEntry(date: day, kcal: 0)
//        }
//        .reversed()
//    }
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Kcal trong 7 ngày")
//                .font(.system(size: 20, weight: .bold))
//                .padding(.top, 16)
//                .padding(.horizontal)
//
//            VStack {
//                Chart {
//                    ForEach(animatedData) { entry in
//                        BarMark(
//                            x: .value("Ngày", entry.date, unit: .day),
//                            y: .value("Kcal", entry.kcal)
//                        )
//                        .foregroundStyle(Color.primaryGreen)
//                        // Giữ X cố định dựa trên ngày để tránh animation trục X
//                        .id(entry.date)
//                    }
//                }
//                .chartXAxis {
//                    AxisMarks(values: .stride(by: .day)) {
//                        AxisGridLine()
//                        AxisValueLabel(format: .dateTime.day().month())
//                    }
//                }
//                .frame(height: 200)
//                .padding(.horizontal)
//                .animation(.easeOut(duration: 1), value: animatedData)
//
//                Text("Biểu đồ Kcal In cho 7 ngày gần nhất")
//                    .font(.footnote)
//                    .foregroundColor(.secondary)
//                    .frame(maxWidth: .infinity)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//            }
//            .padding(.top, 24)
//            .padding(.bottom, 16)
//            .background(Color.white)
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
//            .padding(.horizontal)
//        }
//        .padding(.top)
//        .onAppear {
//            // Bước 1: set kcal = 0 để cột ở mức thấp
//            animatedData = last7DaysData.map { KcalEntry(date: $0.date, kcal: 0) }
//
//            // Bước 2: sau 0.2s gán lại dữ liệu thật => cột cao dần
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                animatedData = last7DaysData
//            }
//        }
//    }
//}
