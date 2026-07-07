//
//  NativeAd.swift
//  GoodFood_App
//
//  Created by Guest User on 3/9/25.

import GoogleMobileAds
import SwiftUI

struct NativeAdSwiftUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomNativeAdView {
        let nativeAdView = CustomNativeAdView(frame: .zero)

        context.coordinator.adLoader = AdLoader(
            adUnitID: "/21775744923/example/native",
//            adUnitID: "ca-app-pub-3940256099942544/3986624511",
            rootViewController: UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
                .first,
            adTypes: [.native],
            options: nil
        )

        context.coordinator.adLoader?.delegate = context.coordinator
        context.coordinator.nativeAdView = nativeAdView
        context.coordinator.adLoader?.load(Request())

        print("Đã gọi adLoader.load(Request())")
        
        return nativeAdView
    }
    
    func updateUIView(_ uiView: CustomNativeAdView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, NativeAdLoaderDelegate {
        var nativeAdView: CustomNativeAdView?
        var adLoader: AdLoader?
        
        func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
            print("Loaded Native Ad: \(nativeAd)")
            guard let nativeAdView = nativeAdView else { return }
            
            // bind data
            (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
            (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
            (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
            (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

            nativeAdView.nativeAd = nativeAd
        }
        
        func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
            print("Failed to load Native Ad: \(error.localizedDescription)")
        }
    }
}
