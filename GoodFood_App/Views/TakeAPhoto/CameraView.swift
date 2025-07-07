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
    let geminiService = GeminiService()

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
                    guard let selectedImage = image else { return }
                    isGenerating = true
                    geminiService.detectDishAndIngredients(from: selectedImage) { result in
                        DispatchQueue.main.async {
                            isGenerating = false
                            switch result {
                            case .success(let text):
                                print("Kết quả Gemini:")
                                print(text) // thể hiện ra UI sau này
                            case .failure(let error):
                                print("Lỗi Gemini: \(error.localizedDescription)")
                            }
                        }
                    }
                }) {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Nhận diện món ăn")
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
