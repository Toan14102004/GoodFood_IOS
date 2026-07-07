//
//  GoodFood_AppApp.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import Firebase
import GoogleMobileAds
import SwiftUI

@main
struct GoodFood_AppApp: App {
    @StateObject var languageViewModel = LanguageViewModel()
    @StateObject var subscriptionManager = SubscriptionManager()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var languageManager = LanguageManager()
    

    let persistenceController = PersistenceController.shared
//    @StateObject var healthTracker = HealthTracker()

    // Tạo delegate
    let notificationDelegate = NotificationDelegate()

    init() {
        FirebaseApp.configure()

        MobileAds.shared.start(completionHandler: nil)

        // Gán delegate trước khi request/schedule
        UNUserNotificationCenter.current().delegate = notificationDelegate

        NotificationManager.instance.requestAuthorization()
        NotificationManager.instance.scheduleNotification()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(subscriptionManager)
                .environmentObject(languageManager)
        }
    }
}
