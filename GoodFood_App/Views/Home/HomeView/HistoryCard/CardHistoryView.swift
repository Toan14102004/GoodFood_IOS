//
//  CardHistoryView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct CardHistoryView: View {
    @Binding var KcalIn: Double
    @Binding var KcalOut: Double
    @Binding var Fat: Double
    @Binding var Carbs: Double
    @Binding var Protein: Double

    var netKcal: Double {
        return KcalOut - KcalIn
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nhật kí")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 16)
                .padding(.horizontal) // Căn lề trái + phải như phần nội dung

            // Nội dung thẻ
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nạp vào")
                            .font(.subheadline)
                        Text("\(Int(KcalIn)) Kcal")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 8)

                        Text("Tiêu hao")
                            .font(.subheadline)
                        Text("\(Int(KcalOut)) Kcal")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 8)
                    }

                    LottieView(name: "iconHome2", loopMode: .loop)
                        .frame(width: 120, height: 120)

                    Spacer()

                    KcalCircleView(NetKcal: netKcal, kcalIn: KcalIn)
                }

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.3))
                    .padding(.vertical, 4)

                HStack(spacing: 60) {
                    VStack {
                        Text("Carbs")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 8)

                        Text("\(Carbs, specifier: "%.1f")g còn lại")
                            .font(.system(size: 13))
                    }
                    VStack {
                        Text("Protein")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 8)

                        Text("\(Protein, specifier: "%.1f")g còn lại")
                            .font(.system(size: 13))
                    }
                    VStack {
                        Text("Fat")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.bottom, 8)

                        Text("\(Fat, specifier: "%.1f")g còn lại")
                            .font(.system(size: 13))
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
        }
    }
}
