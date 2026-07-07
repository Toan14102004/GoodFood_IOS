//
//  NativeAdView.swift
//  GoodFood_App
//
//  Created by Guest User on 29/8/25.
//
// NativeAdSwiftUIView()
//    .frame(height: 150)
//    .padding()

// import GoogleMobileAds
// import UIKit
//
// class CustomNativeAdView: NativeAdView {
//    let headlineLabel = UILabel()
//    let bodyLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        // headline
//        headlineLabel.font = .boldSystemFont(ofSize: 16)
//        headlineLabel.numberOfLines = 2
//        addSubview(headlineLabel)
//        self.headlineView = headlineLabel
//
//        // body
//        bodyLabel.font = .systemFont(ofSize: 14)
//        bodyLabel.numberOfLines = 3
//        addSubview(bodyLabel)
//        self.bodyView = bodyLabel
//
//        // AutoLayout
//        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
//        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            headlineLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//
//            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
//            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
//        ])
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
// }

import GoogleMobileAds
import UIKit

class CustomNativeAdView: NativeAdView {
    let headlineLabel = UILabel()
    let bodyLabel = UILabel()
    let iconImageView = UIImageView()
    let callToActionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        // headline
        headlineLabel.font = .boldSystemFont(ofSize: 16)
        headlineLabel.numberOfLines = 2
        addSubview(headlineLabel)
        self.headlineView = headlineLabel

        // body
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 3
        addSubview(bodyLabel)
        self.bodyView = bodyLabel

        // icon
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        self.iconView = iconImageView

        // CTA
        callToActionButton.backgroundColor = .systemBlue
        callToActionButton.setTitleColor(.white, for: .normal)
        callToActionButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        callToActionButton.layer.cornerRadius = 6
        addSubview(callToActionButton)
        self.callToActionView = callToActionButton

        // AutoLayout
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        callToActionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),

            headlineLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headlineLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            callToActionButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            callToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            callToActionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            callToActionButton.heightAnchor.constraint(equalToConstant: 36),
            callToActionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
