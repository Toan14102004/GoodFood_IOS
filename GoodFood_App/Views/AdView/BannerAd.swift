//
//  BannerAd.swift
//  GoodFood_App
//
//  Created by Guest User on 27/8/25.
//
import GoogleMobileAds
import SwiftUI

struct BannerAd: UIViewRepresentable {
    var unitID: String

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
 //GADAdSizeFullWidthPortraitWithHeight
    //GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth
    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: fullWidthLandscape(height: 50)
)
        banner.adUnitID = unitID
        banner.rootViewController = UIApplication.shared.getRootViewController()
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}

    class Coordinator: NSObject, BannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print(" Banner loaded successfully")
            print(#function)
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print(#function + ": " + error.localizedDescription)
        }

        func bannerViewDidRecordClick(_ bannerView: BannerView) {
            print(#function)
        }

        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            print(#function)
        }

        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print(#function)
        }

        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            print(#function)
        }

        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print(#function)
        }
    }
}

extension UIApplication {
    func getRootViewController() -> UIViewController? {
        guard let screen = UIApplication.shared.connectedScenes
            .first as? UIWindowScene
        else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
