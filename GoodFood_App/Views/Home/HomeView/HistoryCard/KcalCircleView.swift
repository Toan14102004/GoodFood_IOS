//
//  KcalCircleView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import SwiftUI

struct KcalCircleView: View {
    var NetKcal: Double // kcal còn lại
    var kcalIn: Double // tổng kcal in

    var percentage: Double {
        NetKcal / kcalIn
    }

    var body: some View {
        ZStack {
            // Vòng tròn nền
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 10)

            // Vòng tròn phần trăm
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // bắt đầu từ đỉnh

            // Text hiển thị bên trong
            VStack {
                Text("Còn lại")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("\(Int(NetKcal)) Kcal")
                    .font(.system(size: 10, weight: .bold))
            }
        }
        .frame(width: 80, height: 80)
    }
}
