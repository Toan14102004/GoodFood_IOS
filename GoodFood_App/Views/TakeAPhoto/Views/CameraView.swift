//
//  CameraView.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
// Color(red: 144/255, green: 185/255, blue: 78/255)
// .ignoresSafeArea(edges: .top)
import CoreML
import PhotosUI
import SwiftUI
import UIKit
import Vision

struct CameraView: View {
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var goToSubscription = false
    @State private var showImagePicker = false
    @State private var image: UIImage?
    @State private var isGenerating = false
    @State private var detectedDish: Dish?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @StateObject var firebaseService = FirebaseService()
    @State private var detectingMethod: String? = nil // "gemini" hoặc "coreml"

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(languageManager.localizedString("Chụp ảnh món ăn hoặc tải lên"))
                    .font(.title3)
                    .bold()
                    .padding(.top, 25)

                ScrollView {
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
                            .overlay(Text(languageManager.localizedString("Chưa có ảnh")).foregroundColor(.gray))
                            .cornerRadius(12)
                    }

                    HStack {
                        Button(action: {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                sourceType = .camera
                                showImagePicker = true
                            } else {
                                print("Camera không khả dụng")
                            }
                        }) {
                            Label(languageManager.localizedString("Chụp ảnh"), systemImage: "camera")
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: {
                            sourceType = .photoLibrary
                            showImagePicker = true
                        }) {
                            Label(languageManager.localizedString("Tải ảnh"), systemImage: "photo.on.rectangle")
                        }
                        .buttonStyle(.bordered)
                    }

                    if image != nil {
                        if detectingMethod != nil {
                            HStack {
                                Spacer()
                                LottieView(name: "loading", loopMode: .loop)
                                    .frame(width: 150, height: 150)
                                    .tint(.gray)
                                Spacer()
                            }
                            .padding(.top)
                        } else {
                            Spacer()
                            HStack {
                                Button(action: {
                                    detectingMethod = "gemini"
                                    detectDish()
                                }) {
                                    Text(languageManager.localizedString("Gemini"))
                                }
                                .buttonStyle(.borderedProminent)
                                .padding(.top)

                                Button("Core ML") {
                                    if subscriptionManager.hasActiveSubscription() {
                                        detectingMethod = "coreml"
                                        detectDishWithCoreML()
                                    } else {
                                        //  nếu chưa mua -> push sang SubscriptionView
                                        goToSubscription = true
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .padding(.top)
                            }
                        }
                    }

                    Spacer()
                }
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image, sourceType: sourceType)
            }
            .sheet(item: $detectedDish) { dish in
                DishDetailView(dish: dish)
            }
            .navigationDestination(isPresented: $goToSubscription) { //  Navigation sang SubscriptionView
                SubscriptionView()
                    .environmentObject(subscriptionManager)
            }
        }
        .onDisappear {
            image = nil
        }
    }
}

extension CameraView {
    func detectDish() {
        guard let image = image else { return }
        isGenerating = true

        GeminiService.shared.detectDishAndIngredients(from: image) { result in
            DispatchQueue.main.async {
                self.isGenerating = false
                self.detectingMethod = nil
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

    func detectDishWithCoreML() {
        guard let image = image else { return }
        isGenerating = true
        var dish = Dish()

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let model = try DishsClassifier5(configuration: MLModelConfiguration())
                print(model.model.modelDescription.inputDescriptionsByName)

                guard let resizedImage = image.resize(to: CGSize(width: 299, height: 299)),
                      let buffer = resizedImage.toCVPixelBuffer()
                else {
                    DispatchQueue.main.async { self.isGenerating = false }
                    return
                }

                let prediction = try model.prediction(image: buffer)
                let label = prediction.target

                // Mapping --> thông tin món ăn
                let displayName = labelMapping[label] ?? label
                let foodInfo = foodDatabase[label]

                print("CORE ML ")
                print("Label: \(label) (\(displayName))")

                if let food = foodInfo {
                    print("Calories: \(food.nutritionFacts.calories)")
                    print("Nguyên liệu: \(food.ingredients.map { $0.name }.joined(separator: ", "))")
                }

                DispatchQueue.main.async {
                    self.isGenerating = false
                    self.detectingMethod = nil

                    dish.name = displayName
                    dish.nutritionFacts = foodInfo?.nutritionFacts ?? NutritionFacts()
                    dish.ingredients = foodInfo?.ingredients ?? []
                    if let savedImageName = saveImageToDocuments(image, withName: dish.name ?? UUID().uuidString) {
                        dish.image = savedImageName
                        
                        if let localImage = loadImageFromDocuments(named: savedImageName) {
                            firebaseService.uploadDishImage(localImage, imageName: savedImageName) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let downloadURL):
                                        dish.image = downloadURL.absoluteString
                                        print("Đã upload ảnh với URL: \(dish.image ?? "")")
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
                        
                    }else {
                        print("Không lưu được ảnh vào Documents.")
                    }
                    self.detectedDish = dish
                }
            } catch {
                DispatchQueue.main.async {
                    self.isGenerating = false
                    self.detectingMethod = nil
                    print("Lỗi Core ML: \(error)")
                }
            }
        }
    }
}
