//
//  NotifiViewModel.swift
//  GoodFood_App
//
//  Created by Guest User on 15/7/25.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI
import UserNotifications

class NotifiViewModel: ObservableObject {
    @Published var notifications: [NotifiModel] = []
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()

    var userID: String {
        Auth.auth().currentUser?.uid ?? "default_user"
    }

    private var cancellables = Set<AnyCancellable>() // giữ lại các subscription Combine để không bị huỷ sớm
    private var healthTracker: HealthTracker

    init(healthTracker: HealthTracker) {
        self.healthTracker = healthTracker
        observeHealthChanges()
        getListNotifi()
    }

    private func observeHealthChanges() {
        healthTracker.$totalCalories
            .sink { [weak self] calories in
                guard let self = self else { return }

                if calories > 2000 {
                    let today = formattedToday()
                    self.addNotification(
                        title: "Vượt ngưỡng calo!",
                        content: "Bạn đã nạp \(Int(calories)) kcal vào ngày \(today) rồi!"
                    )
                }
            }
            .store(in: &cancellables)
    }

    private func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: Date())
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
        saveNotifyToFirebase(newNoti) { result in
            switch result {
            case .success:
                print("Successfully saved to firebase")
            case .failure(let error):
                print("Failed to save to firebase: \(error)")
            }
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

    private func saveNotifyToFirebase(_ notifycation: NotifiModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let todayRef = db.collection("User").document(userID).collection("listNotify")
        var notifyData: [String: Any] = [
            "id": notifycation.id.uuidString,
            "title": notifycation.title ?? "title defaut",
            "content": notifycation.content ?? "content defaut",
            "dateTime": Timestamp(date: notifycation.dateTime ?? Date())
        ]

        todayRef.addDocument(data: notifyData) { err in
            if let err = err {
                completion(.failure(err))
                return print("Error adding document: \(err)")
            } else {
                completion(.success(()))
            }
        }
    }

    func getListNotifi() {
        db.collection("User")
            .document(userID)
            .collection("listNotify")
            .order(by: "dateTime", descending: true) // lấy mới nhất trước
            .getDocuments { [weak self] querySnapshot, err in
                guard let self = self else { return }

                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }

                var listNotify: [NotifiModel] = []

                querySnapshot?.documents.forEach { document in
                    let data = document.data()

                    let idString = data["id"] as? String ?? UUID().uuidString
                    let id = UUID(uuidString: idString) ?? UUID()

                    let title = data["title"] as? String ?? "No title"
                    let content = data["content"] as? String ?? "No content"

                    // Firestore Timestamp -> Date
                    var date = Date()
                    if let ts = data["dateTime"] as? Timestamp {
                        date = ts.dateValue()
                    } else if let dateStr = data["dateTime"] as? String {
                        // fallback if lưu string
                        let formatter = ISO8601DateFormatter()
                        if let parsedDate = formatter.date(from: dateStr) {
                            date = parsedDate
                        }
                    }

                    let noti = NotifiModel(
                        id: id,
                        title: title,
                        content: content,
                        dateTime: date
                    )
                    listNotify.append(noti)
                    print("Notify loaded → id: \(id), title: \(title), content: \(content), date: \(date)")
                }

                DispatchQueue.main.async {
                    self.notifications = listNotify
                }
            }
    }
}
