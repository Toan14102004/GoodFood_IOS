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
                .padding(.horizontal) // Căn lề trái + phải như phần nội dung

            Chart {
                ForEach(data) { entry in
                    BarMark(
                        x: .value("Ngày", entry.date, unit: .day),
                        y: .value("Kcal", entry.kcal)
                    )
                    .foregroundStyle(Color.primaryGreen)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
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
        .padding(.top)
    }
}
