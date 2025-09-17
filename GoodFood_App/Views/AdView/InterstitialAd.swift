//
//  InterstitialAd.swift
//  GoodFood_App
//
//  Created by Guest User on 28/8/25.
//
import GoogleMobileAds
import SwiftUI
import UIKit

class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private var interstitial: InterstitialAd?
    private var adUnitID = "ca-app-pub-3940256099942544/4411468910"
    var onAdDismissed: (() -> Void)?
    
    override init() {
        super.init()
        loadAd()
    }
    
    func loadAd() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { ad, error in
            if let error = error {
                print("Không load được interstitial: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            print("Interstitial đã sẵn sàng")
        }
    }
    
    // Hiển thị quảng cáo
    func showAd(from rootViewController: UIViewController) {
        if let ad = interstitial {
            ad.present(from: rootViewController)
        } else {
//            print(" Interstitial chưa sẵn sàng, load lại...")
//            loadAd()
            print("Ad not ready")
            onAdDismissed?() // fallback: nếu chưa load kịp thì cho vào luôn
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
//        print("Quảng cáo đóng -> Load lại")
//        loadAd()
        print("Ad dismissed")
        onAdDismissed?()
        loadAd() // load lại cho lần sau
    }
    
    func ad(_ ad: any FullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: any Error)
    {
        print("Lỗi khi show ad: \(error.localizedDescription)")
        loadAd()
    }
}
