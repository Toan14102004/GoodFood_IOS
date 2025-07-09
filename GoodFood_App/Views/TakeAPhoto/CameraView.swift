////
////  CameraView.swift
////  GoodFood_App
////
////  Created by Guest User on 30/6/25.
////

import PhotosUI
import SwiftUI

struct CameraView: View {
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isGenerating = false
    @State private var detectedDish: Dish? // Món ăn sau khi nhận diện
    @StateObject var firebaseService = FirebaseService()

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
                    detectDish()
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
        .sheet(item: $detectedDish) { dish in
            DishDetailView(dish: dish)
        }
    }

    func detectDish() {
        guard let image = image else { return }
        isGenerating = true

        GeminiService.shared.detectDishAndIngredients(from: image) { result in
            DispatchQueue.main.async {
                isGenerating = false
                switch result {
                case .success(let responseText):
                    print("Gemini Response: \(responseText)")
                    if var dish = GeminiService.shared.parseDish(from: responseText) {
                        if let savedImageName = saveImageToDocuments(image, withName: dish.name ?? UUID().uuidString) {
                            dish.image = savedImageName

                            if let localImage = loadImageFromDocuments(named: savedImageName) {
                                firebaseService.uploadDishImage(localImage, imageName: savedImageName) { result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success(let downloadURL):
                                            dish.image = downloadURL.absoluteString
                                            print("Đã upload ảnh với URL: \(dish.image ?? "")")
                                            firebaseService.addDishToToday(dish, calories: dish.nutritionFacts?.calories ?? 0, protein: dish.nutritionFacts?.protein ?? 0, carbs: dish.nutritionFacts?.carbohydrates ?? 0, fat: dish.nutritionFacts?.fat ?? 0, nutritionFacts: nil) { result in
                                                switch result {
                                                case .success:
                                                    print("Đã lưu món ăn lên Firestore thành công!")
                                                case .failure(let error):
                                                    print("Lỗi khi lưu món ăn lên Firestore: \(error)")
                                                }
                                            }

                                            self.detectedDish = dish
                                        case .failure(let error):
                                            print("Lỗi upload ảnh: \(error)")
                                            self.detectedDish = dish
                                        }
                                    }
                                }
                            } else {
                                print("Không load được ảnh từ Documents.")
                                self.detectedDish = dish
                            }
                        } else {
                            print("Không lưu được ảnh vào Documents.")
                            self.detectedDish = dish
                        }
                    } else {
                        print("Không parse được món ăn.")
                    }
                case .failure(let error):
                    print("Lỗi Gemini: \(error.localizedDescription)")
                }
            }
        }
    }
}
