//
//  NotificationManager.swift
//  GoodFood_App
//
//  Created by Guest User on 23/7/25.
//
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print(" Notification permission granted")
            } else if let error = error {
                print(" Error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "What to eat today? 🤔"
        content.body = "Goodfood has a few attractive suggestions waiting for you!"
        content.sound = .default

        // send sau 5 giây
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(" Lỗi khi lên lịch thông báo: \(error)")
            } else {
                print(" Đã lên lịch thông báo")
            }
        }
    }
}
