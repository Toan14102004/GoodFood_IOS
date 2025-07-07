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
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
