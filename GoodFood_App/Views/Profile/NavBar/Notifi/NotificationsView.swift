//
//  Notifications.swift
//  GoodFood_App
//
//  Created by Guest User on 15/7/25.
//
import Foundation
import SwiftUI

struct NotifiModel: Codable, Identifiable {
    var id: UUID
    var title: String?
    var content: String?
    var dateTime: Date?
}

struct CardNotifi: View {
    var item: NotifiModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title ?? "Thông báo")
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            Text(item.content ?? "Hôm nay bạn đã ...")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            if let date = item.dateTime {
                Text(date, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal,24)
        .padding(.vertical,16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .frame(width: 350, height: 100)
    }
}

struct NotificationsView: View {
    @State var notifications: [NotifiModel] = [
        NotifiModel(id: UUID(), title: "Hoàn thành mục tiêu", content: "Bạn đã đạt chỉ tiêu hôm nay!", dateTime: Date()),
        NotifiModel(id: UUID(), title: "Nhắc nhở", content: "Đừng quên uống nước!", dateTime: Date())
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("THÔNG BÁO")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                ForEach(notifications) { item in
                    CardNotifi(item: item)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
}
