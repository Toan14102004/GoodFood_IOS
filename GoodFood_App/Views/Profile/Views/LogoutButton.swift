//
//  LogoutButton.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import SwiftUI

struct LogoutButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 24))
                .background(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                )
        }
        .offset(x: 5, y: 70)
    }
}
