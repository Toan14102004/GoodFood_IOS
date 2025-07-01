//
//  ToolbarButtons.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import SwiftUI

struct ToolbarButtons: View {
    var onCalendarTap: () -> Void
    var onAddTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onCalendarTap) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(Color.primaryGreen)
            }

            Button(action: onAddTap) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(Color.primaryGreen)
            }
        }
    }
}
