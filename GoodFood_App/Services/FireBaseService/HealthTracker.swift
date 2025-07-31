//
//  HealthTracker.swift
//  GoodFood_App
//
//  Created by Guest User on 23/7/25.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class HealthTracker: ObservableObject {
    @Published var totalCalories: Double = 0.0
    @Published var totalCarbs: Double = 0.0
    @Published var totalProtein: Double = 0.0
    @Published var totalFat: Double = 0.0

    private var dailyListener: ListenerRegistration?

    private var db = Firestore.firestore()

    var userID: String {
        Auth.auth().currentUser?.uid ?? "default_user"
    }

    init() {
        listenToDailyRecord()
    }

    func dailyRecordRef(for date: Date) -> DocumentReference {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateID = formatter.string(from: date)
        return db.collection("User")
            .document(userID)
            .collection("dailyRecord")
            .document(dateID)
    }

    // Lắng nghe thay đổi real-time
    func listenToDailyRecord() {
        dailyListener = dailyRecordRef(for: Date())
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let data = documentSnapshot?.data() else {
                    self.totalCalories = 0
                    self.totalCarbs = 0
                    self.totalProtein = 0
                    self.totalFat = 0
                    return
                }

                self.totalCalories = data["kcalIn"] as? Double ?? 0.0
                self.totalCarbs = data["carbs"] as? Double ?? 0.0
                self.totalProtein = data["protein"] as? Double ?? 0.0
                self.totalFat = data["fat"] as? Double ?? 0.0
            }
    }

    deinit {
        dailyListener?.remove()
    }
}
