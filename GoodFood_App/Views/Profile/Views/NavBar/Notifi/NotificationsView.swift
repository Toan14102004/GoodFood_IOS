//
//  Notifications.swift
//  GoodFood_App
//
//  Created by Guest User on 15/7/25.
//
import Foundation
import SwiftUI

struct CardNotifi: View {
    var item: NotifiModel
    @Binding var selectedItem: NotifiModel?

    var body: some View {
        Button(action: {
            selectedItem = item
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.title ?? "Thông báo")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 16)

                Text(item.content ?? "Hôm nay bạn đã ...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail) // quyết định đặt dấu ... ở đâu ( tail thì ở cuối , head ở đầu , middle ở giữa)
                    .padding(.horizontal, 20)

                if let date = item.dateTime {
                    HStack {
                        Spacer()
                        HStack {
                            Text(date, style: .time)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)

                            Text(dateFormatted(date: date))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 144/255, green: 185/255, blue: 78/255), lineWidth: 2)
                                .padding(.trailing, 10)
                        )
                    }
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct DetailCardInfor: View {
    var notification: NotifiModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LottieView(name: "Notifications", loopMode: .loop)
                .frame(height: 150)
                .padding()

            Text(notification.title ?? "Thông báo")
                .font(.headline)
                .font(.system(size: 24))
                .bold()
                .padding(.vertical, 16)

            Text(notification.content ?? "Không có nội dung")
                .font(.body)

            Spacer()
        }
        .padding()
    }
}

struct NotificationsView: View {
    @EnvironmentObject var healthTracker: HealthTracker
    @StateObject private var notifiVM: NotifiViewModel

    @State private var selectedNotification: NotifiModel? = nil

    init() {
        _notifiVM = StateObject(wrappedValue: NotifiViewModel(healthTracker: HealthTracker()))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("THÔNG BÁO")
                        .font(.title2)
                        .bold()
                        .padding(.top)

                    ForEach(notifiVM.notifications) { item in
                        CardNotifi(item: item, selectedItem: $selectedNotification)
                            .frame(width: 350, height: 100)
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .sheet(item: $selectedNotification) { item in
                DetailCardInfor(notification: item)
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("Notification permission granted: \(granted)")
            }
        }
    }
}
