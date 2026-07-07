//
//  RewardedAd.swift
//  GoodFood_App
//
//  Created by Guest User on 28/8/25.
//
import GoogleMobileAds
import SwiftUI
import UIKit

final class RewardedAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    private var rewardedAd: RewardedAd?
    
    private let adUnitID = "ca-app-pub-3940256099942544/1712485313"
    
    @Published var isReady: Bool = false
    
    override init() {
        super.init()
        loadRewardedAd()
    }
    
    func loadRewardedAd() {
        let request = Request()
        RewardedAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load rewarded ad: \(error.localizedDescription)")
                self?.isReady = false
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.isReady = true
            print("Rewarded ad loaded")
        }
    }
    
    func showRewardedAd(from root: UIViewController, onReward: @escaping (AdReward) -> Void) {
        guard let ad = rewardedAd else {
            print("Ad not ready")
            return
        }
        ad.present(from: root) {
            let reward = ad.adReward
            print("User earned reward: \(reward.amount) \(reward.type)")
            onReward(reward)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("Rewarded ad dismissed")
        isReady = false
        loadRewardedAd()
    }
}
