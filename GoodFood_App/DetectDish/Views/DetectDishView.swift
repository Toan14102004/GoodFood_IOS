//
//  DetectDishView.swift
//  GoodFood_App
//
//  Created by Guest User on 7/8/25.
//
// import SwiftUI
// import CoreML
// import Vision
// import UIKit
//
// struct DetectDishView: View {
//    @State private var inputImage: UIImage?
//    @State private var showImagePicker = false
//    @State private var resizeImage: UIImage?
//    @State private var prediction: String = "Chưa có dự đoán"
//    @State private var navigateToDetail = false
//    @State private var resizedImageForDetail: UIImage?
//    @State private var confidence: Double = 0.0
//
//    let classifier = DishsClassifier4()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                VStack(spacing: 20) {
//                    if let img = inputImage {
//                        Image(uiImage: img)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 300)
//                    }
//
//                    Button("Chọn ảnh") {
//                        self.showImagePicker = true
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//
//                    Text(prediction)
//                        .padding()
//                        .foregroundColor(.green)
//                }
//                .sheet(isPresented: $showImagePicker) {
////                    ImagePicker(image: $inputImage)
//                    ImagePicker(image: self.$inputImage, onImagePicked: self.classifyImage)
//                }
//                .onChange(of: inputImage) { newImage in
//                    if let img = newImage {
//                        classifyImage(img)
//                    }
//                }
//            }
//            .navigationDestination(isPresented: $navigateToDetail) {
//                if let resizedImageForDetail = resizedImageForDetail {
//                    DetailImage(image: resizedImageForDetail)
//                }
//            }
//        }
//    }
//
//    func classifyImage(_ uiImage: UIImage) {
//        print("Ảnh trước khi xử lí có size: \(uiImage.size)")
//
//        // 1. Sửa orientation
//        let fixedImage = uiImage.fixedOrientation()
//
//        logPixelColors(of: uiImage)
////        guard let resizedImage = uiImage.centerCropAndResize(to: CGSize(width: 299, height: 299)),
//        guard let resizedImage = fixedImage.centerCropAndResize(to: CGSize(width: 299, height: 299)),
//              let buffer = resizedImage.toCVPixelBuffer()
//        else {
//            prediction = "Không thể xử lý ảnh!"
//            return
//        }
//
//        resizeImage = resizedImage
//        resizedImageForDetail = resizedImage
//        navigateToDetail = true
//
//
//        do {
//            let config = MLModelConfiguration()
//            let model = try DishsClassifier4(configuration: config)
//
//            let output = try model.prediction(image: buffer)
//            let label = output.target
//            let confidence = output.targetProbability[label] ?? 0
//
////            DispatchQueue.main.async {
////                prediction = "Dự đoán: \(label) - \(Int(confidence * 100))%"
////                print("Dự đoán : \(label) - \(Int(confidence * 100))%")
////            }
//            DispatchQueue.main.async {
//                let (foodInfo, displayName) = getFoodInfoAndDisplayName(from: label)
//
//                prediction = """
//                Dự đoán: \(displayName) - \(Int(confidence * 100))%
//                \(foodInfo != nil ? "Có thông tin chi tiết món ăn" : "Không tìm thấy thông tin món ăn")
//                """
//
//                print("Dự đoán: \(displayName) - \(Int(confidence * 100))%")
//                if let foodInfo = foodInfo {
//                    print("Calories: \((foodInfo.nutritionFacts.calories) ?? 1000)")
//                    print("fat: \((foodInfo.nutritionFacts.fat) ?? 1000)")
//                    print("saturatedFat: \((foodInfo.nutritionFacts.saturatedFat) ?? 1000)")
//                    print("protein: \(foodInfo.nutritionFacts.protein)")
//                    print("carbohydrates: \(foodInfo.nutritionFacts.carbohydrates)")
//                    print("sugar: \(foodInfo.nutritionFacts.sugar)")
//                    print("fiber: \(foodInfo.nutritionFacts.fiber)")
//                    print("cholesterol: \(foodInfo.nutritionFacts.cholesterol)")
//                    print("sodium: \(foodInfo.nutritionFacts.sodium)")
//                    print("calcium: \(foodInfo.nutritionFacts.calcium)")
//                    print("iron: \(foodInfo.nutritionFacts.iron)")
//                    print("potassium: \(foodInfo.nutritionFacts.potassium)")
//
//                }
//            }
//
//        } catch {
//            DispatchQueue.main.async {
//                prediction = "Lỗi xử lý mô hình: \(error.localizedDescription)"
//            }
//            print("Chi tiết lỗi: \(error)")
//        }
//    }
//
//    func logPixelColors(of image: UIImage) {
//        guard let cgImage = image.cgImage else {
//            print("Image has no CGImage")
//            return
//        }
//
//        let width = cgImage.width
//        let height = cgImage.height
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bytesPerPixel = 4
//        let bytesPerRow = bytesPerPixel * width
//        let bitsPerComponent = 8
//        var pixelData = [UInt8](repeating: 0, count: Int(height * width * 4))
//
//        guard let context = CGContext(data: &pixelData,
//                                      width: width,
//                                      height: height,
//                                      bitsPerComponent: bitsPerComponent,
//                                      bytesPerRow: bytesPerRow,
//                                      space: colorSpace,
//                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//        else {
//            print("Could not create CGContext")
//            return
//        }
//
//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//
//        // Log 5 điểm ngẫu nhiên
//        let samplePoints = [(0, 0), (width/2, height/2), (width-1, height-1), (10, 10), (width/4, height/4)]
//        for (x, y) in samplePoints {
//            let index = (y * width + x) * 4
//            if index + 3 < pixelData.count {
//                let r = pixelData[index]
//                let g = pixelData[index + 1]
//                let b = pixelData[index + 2]
//                let a = pixelData[index + 3]
//                print("Pixel (\(x), \(y)) - R:\(r), G:\(g), B:\(b), A:\(a)")
//            }
//        }
//    }
//
//    func getFoodInfoAndDisplayName(from identifier: String) -> (FoodInfo?, String) {
//        let key = foodKeyByLabel[identifier] ?? identifier
//        let displayName = labelMapping[identifier] ?? "Không rõ"
//        return (foodDatabase[key], displayName)
//    }
//
//
// }
//
//
