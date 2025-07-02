//
//  CameraView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//

import PhotosUI
import SwiftUI

struct CameraView: View {
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isGenerating = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Chụp ảnh món ăn hoặc tải lên")
                .font(.title3)
                .bold()
                .padding(.top)

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 600)
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 600)
                    .overlay(Text("Chưa có ảnh").foregroundColor(.gray))
                    .cornerRadius(12)
            }

            HStack {
                Button(action: {
                    sourceType = .camera
                    showImagePicker = true
                }) {
                    Label("Chụp ảnh", systemImage: "camera")
                }
                .buttonStyle(.borderedProminent)

                Button(action: {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }) {
                    Label("Tải ảnh", systemImage: "photo.on.rectangle")
                }
                .buttonStyle(.bordered)
            }

            if image != nil {
                Button(action: {
                    isGenerating = true
                    // Gọi API nhận diện nguyên liệu tại đây
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isGenerating = false
                        print("Generated ingredients từ ảnh.")
                    }
                }) {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text(" Generate Ingredients")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image, sourceType: sourceType)
        }
    }
}
