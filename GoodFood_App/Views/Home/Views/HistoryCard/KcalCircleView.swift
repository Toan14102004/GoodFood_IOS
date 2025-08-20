//
//  KcalCircleView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.

import SwiftUI

struct KcalCircleView: View {
    var percentage: Double
    var netKcal: Double // kcal còn lại
    var kcalOut: Double // tổng kcal cần nạp

    @State private var animatedPercentage: Double = 0

    var body: some View {
        ZStack {
            // vòng tròn của KcaIn
            Circle()
                .stroke(Color.orange.opacity(0.2), lineWidth: 18)

            Circle()
                .trim(from: 0, to: percentage)
                .stroke(
                    Color.primaryGreen,
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 2.5), value: percentage)

            VStack {
                Text("Còn lại")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("\(Int(netKcal)) Kcal")
                    .font(.system(size: 10, weight: .bold))
            }
        }
        .frame(width: 80, height: 80)
        .onAppear {
            animatedPercentage = percentage
            print("percentage trong trang home : \(percentage)")
            print("animatedPercentage: \(animatedPercentage)")
        }
        .onDisappear {
            animatedPercentage = 0
        }
    }
}
