//
//  NotificationDelegate.swift
//  GoodFood_App
//
//  Created by Guest User on 23/7/25.
//
// Delegate xử lý hiển thị notification khi app đang mở
import SwiftUI

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Hiển thị thông báo khi app đang mở
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.banner, .sound])
    }
}
