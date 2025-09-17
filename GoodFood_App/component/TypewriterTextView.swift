//
//  TypewriterTextView.swift
//  GoodFood_App
//
//  Created by Guest User on 11/9/25.
//
import SwiftUI

struct TypewriterTextView: View {
    let fullText: String
    @State private var displayedText = ""
    @State private var charIndex = 0
    
    var body: some View {
        Text(displayedText)
            .font(.subheadline)
            .padding(.bottom, 8)
            .multilineTextAlignment(.leading)
            .animation(.easeInOut(duration: 0.15), value: displayedText)
            .onAppear {
                startTyping()
            }
    }
    
    private func startTyping() {
        displayedText = ""
        charIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                withAnimation {
                    displayedText.append(fullText[index])
                }
                charIndex += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                    startTyping()
                }
            }
        }
    }
}
