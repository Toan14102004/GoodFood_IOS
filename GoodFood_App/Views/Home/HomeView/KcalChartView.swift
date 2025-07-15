//
//  KcalChartView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import Charts
import SwiftUI

struct KcalChartView: View {
    let data: [KcalEntry]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Kcal trong 7 ngày")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 16)
                .padding(.horizontal)
            VStack {
//                Chart {
//                    ForEach(data) { entry in
//                        BarMark(
//                            x: .value("Ngày", entry.date, unit: .day),
//                            y: .value("Kcal", entry.kcal)
//                        )
//                        .foregroundStyle(Color.primaryGreen)
//                    }
//                }
//                Chart {
//                    ForEach(data) { entry in
//                        LineMark(
//                            x: .value("Ngày", entry.date),
//                            y: .value("Kcal", entry.kcal)
//                        )
//                        .foregroundStyle(Color.primaryGreen)
//                        .symbol(Circle()) // Thêm chấm tròn tại mỗi điểm
//                    }
//                }

//                Chart {
//                    ForEach(data) { entry in
//                        AreaMark(
//                            x: .value("Ngày", entry.date),
//                            y: .value("Kcal", entry.kcal)
//                        )
//                        .foregroundStyle(Color.primaryGreen.opacity(0.3))
//                    }
//
//                    ForEach(data) { entry in
//                        LineMark(
//                            x: .value("Ngày", entry.date),
//                            y: .value("Kcal", entry.kcal)
//                        )
//                        .foregroundStyle(Color.primaryGreen)
//                    }
//                }
                Chart {
                    ForEach(data) { entry in
                        LineMark(
                            x: .value("Ngày", entry.date),
                            y: .value("Kcal", entry.kcal)
                        )
                        .foregroundStyle(Color.primaryGreen)
                        .symbol(Circle()) // Thêm chấm tròn tại mỗi điểm nếu thích
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine()
                        //                    AxisValueLabel(format: .dateTime.weekday(.narrow))
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
