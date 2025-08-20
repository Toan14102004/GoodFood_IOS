//
//  DetailImage.swift
//  GoodFood_App
//
//  Created by Guest User on 7/8/25.
//
import SwiftUI

struct DetailImage: View {
    let image: UIImage

    var body: some View {
        VStack {
            Text("Ảnh đã xử lý")
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

