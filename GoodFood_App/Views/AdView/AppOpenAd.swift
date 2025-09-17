//
//  AppOpenAd.swift
//  GoodFood_App
//
//  Created by Guest User on 28/8/25.
//
import GoogleMobileAds
import UIKit

class AppOpenAdManager: NSObject, ObservableObject {
    private var appOpenAd: AppOpenAd?
    private var loadTime: Date?
    private let adUnitID = "ca-app-pub-3940256099942544/5662855259"

    static let shared = AppOpenAdManager()

    override private init() {
        super.init()
        loadAd()
    }

    func loadAd() {
        AppOpenAd.load(
            with: adUnitID,
            request: Request()
        ) { ad, error in
            if let error = error {
                print("AppOpenAd load failed: \(error.localizedDescription)")
                return
            }
            self.appOpenAd = ad
            self.loadTime = Date()
            print("AppOpenAd loaded successfully")
        }
    }

    func tryToPresentAd() {
        if let ad = appOpenAd, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            if let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first?.rootViewController
            {
                ad.present(from: rootVC)
            }
        } else {
            loadAd()
        }
    }

    private func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        guard let loadTime = loadTime else { return false }
        let now = Date()
        let timeInterval = now.timeIntervalSince(loadTime)
        let hours = timeInterval / (60 * 60)
        return hours < Double(thresholdN)
    }
}
