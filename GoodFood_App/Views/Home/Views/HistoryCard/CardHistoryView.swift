//
//  CardHistoryView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct CardHistoryView: View {
    @Binding var kcalIn: Double
    @Binding var kcalOut: Double
    @Binding var fat: Double
    @Binding var carbs: Double
    @Binding var protein: Double

    var netKcal: Double {
        return kcalOut - kcalIn
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nhật kí")
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 16)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        kcalBox(title: "Nạp vào", value: self.kcalIn)
                        kcalBox(title: "Tiêu hao", value: self.kcalOut)
                    }

                    LottieView(name: "iconHome2", loopMode: .loop)
                        .frame(width: 120, height: 120)

                    Spacer()

                    KcalCircleView(netKcal: self.netKcal, kcalIn: self.kcalIn)
                }

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.3))
                    .padding(.vertical, 4)

                HStack(spacing: 60) {
                    
                    nutriBox(title: "Carbs",value: self.carbs)
                    nutriBox(title: "Protein", value: self.protein)
                    nutriBox(title: "Fat" , value: self.fat)
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

extension CardHistoryView {
    private func kcalBox(title: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.subheadline)
            Text("\(value, specifier: "%.1f") Kcal")
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 8)
        }
    }
    
    private func nutriBox(title: String, value: Double) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .padding(.bottom, 8)

            Text("\(value, specifier: "%.1f")g")
                .font(.system(size: 13))
        }
    }
}
