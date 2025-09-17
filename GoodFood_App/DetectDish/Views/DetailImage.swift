//
//  DetailImage.swift
//  GoodFood_App
//
//  Created by Guest User on 7/8/25.
//
import SwiftUI

struct DetailImage: View {
    @EnvironmentObject var languageManager: LanguageManager
    let image: UIImage

    var body: some View {
        VStack {
            Text(languageManager.localizedString("Ảnh đã xử lý"))
                .font(.title)
                .padding()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 400)

            Spacer()
        }
        .padding()
    }
}
