//
//  NotifiViewModel.swift
//  GoodFood_App
//
//  Created by Guest User on 15/7/25.
//

import Foundation
import Combine
import UserNotifications

class NotifiViewModel: ObservableObject {
    @Published var notifications: [NotifiModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var healthTracker: HealthTracker

    init(healthTracker: HealthTracker) {
        self.healthTracker = healthTracker
        observeHealthChanges()
    }

    private func observeHealthChanges() {
        healthTracker.$totalCalories
            .sink { [weak self] calories in
                guard let self = self else { return }

                if calories > 2000 {
                    self.addNotification(
                        title: "Vượt ngưỡng calo!",
                        content: "Bạn đã nạp \(Int(calories)) kcal hôm nay rồi!"
                    )
                }
            }
            .store(in: &cancellables)

    }

    private func addNotification(title: String, content: String) {
        let newNoti = NotifiModel(
            id: UUID(),
            title: title,
            content: content,
            dateTime: Date()
        )

        DispatchQueue.main.async {
            self.notifications.insert(newNoti, at: 0)
        }

        sendLocalNotification(title: title, body: content)
    }

    private func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
