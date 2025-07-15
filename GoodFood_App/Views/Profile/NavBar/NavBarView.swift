//
//  NavBarView.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import SwiftUI

struct NavBarView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("Tab", selection: $selectedTab) {
                Text("Thông tin").tag(0)
                Text("Cân nặng").tag(1)
                Text("Thông báo").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .frame(height: 45)
            .tint(Color(red: 144/255, green: 185/255, blue: 78/255))

            // Hiển thị view tương ứng
            if selectedTab == 0 {
                InforUser()
            }
            if selectedTab == 1 {
                ChartWeightView()
            }  else if selectedTab == 2 {
                NotificationsView()
                    .background(Color.red.opacity(0.5))
            }
        }
    }
}

