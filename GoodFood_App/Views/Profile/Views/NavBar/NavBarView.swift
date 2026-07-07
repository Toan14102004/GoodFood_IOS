//
//  NavBarView.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

struct NavBarView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var selectedTab = 0

    var body: some View {
        VStack {
            Picker("Tab", selection: $selectedTab) {
                Text(languageManager.localizedString("Thông tin")).tag(0)
                Text(languageManager.localizedString("Cân nặng")).tag(1)
                Text(languageManager.localizedString("Thông báo")).tag(2)
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
            } else if selectedTab == 2 {
                NotificationsView()
            }
        }
    }
}
