//
//  GoodFood_AppApp.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import Firebase
import SwiftUI

@main
struct GoodFood_AppApp: App {
    let persistenceController = PersistenceController.shared
//    @StateObject var healthTracker = HealthTracker()

    // Tạo delegate
    let notificationDelegate = NotificationDelegate()

    init() {
        FirebaseApp.configure()

        // Gán delegate trước khi request/schedule
        UNUserNotificationCenter.current().delegate = notificationDelegate

        NotificationManager.instance.requestAuthorization()
        NotificationManager.instance.scheduleNotification()
    }

    var body: some Scene {
        WindowGroup {
//            WelcomeView()
//                .environmentObject(healthTracker)
            SplashView()
        }
    }
}

