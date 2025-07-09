//
//  GerminiService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
//

import Foundation
import UIKit

class GeminiService {
    static let shared = GeminiService()
    private init() {}
    private let apiKey = "AIzaSyD4lET4epcDKH9t0CqVn36qBki-tXIYi7g"
   
    func detectDishAndIngredients(from image: UIImage, retryCount: Int = 3, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không thể nén ảnh"])))
            return
        }

        let base64Image = imageData.base64EncodedString()

        let requestData: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": """
                        Hãy phân tích món ăn và nguyên liệu trong ảnh này. Trả lời bằng tiếng Việt, đúng JSON, không Markdown, không ký hiệu thừa.
                        JSON phải theo đúng format sau:
                        {
                          "name": "Tên món ăn",
                          "ingredients": [
                            { "name": "Tên nguyên liệu", "quantity": số thập phân, "unit": "đơn vị", "state": "trạng thái (nếu có, có thể null)" }
                          ],
                          "nutritionFacts": {
                            "calories": số,
                            "protein": số,
                            "carbohydrates": số,
                            "fat": số,
                            "saturatedFat": số,
                            "sugar": số,
                            "fiber": số,
                            "cholesterol": số,
                            "sodium": số,
                            "calcium": số,
                            "iron": số,
                            "potassium": số
                          }
                        }
                        Nếu thiếu giá trị nào có thể ước lượng thì hãy ước lượng.
                        """],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ]
        ]

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=\(apiKey)"),
              let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        else {
            completion(.failure(NSError(domain: "URLSerializationError", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }

            print("Response: \(String(data: data, encoding: .utf8) ?? "N/A")")

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                if let error = json?["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    print("Lỗi Gemini: \(message)")
                    
                    if message.contains("overloaded") && retryCount > 0 {
                        print("Thử lại sau 3 giây...")
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            self.detectDishAndIngredients(from: image, retryCount: retryCount - 1, completion: completion)
                        }
                        return
                    }

                    completion(.failure(NSError(domain: "GeminiAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])))
                    return
                }

                guard let candidates = json?["candidates"] as? [[String: Any]],
                      let content = candidates.first?["content"] as? [String: Any],
                      let parts = content["parts"] as? [[String: Any]],
                      let text = parts.first?["text"] as? String else {
                    completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: nil)))
                    return
                }

                completion(.success(text))

            } catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }

    func loadImageFromDocuments(named imageName: String) -> UIImage? {
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsDirectory.appendingPathComponent(imageName)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
            } else {
                print("Không tìm thấy ảnh với tên \(imageName) trong thư mục Documents")
                return nil
            }
        }
    
    
    func parseDish(from geminiResponse: String) -> Dish? {
        let cleanResponse = geminiResponse
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleanResponse.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        
        do {
            let temp = try decoder.decode(GeminiDishResponse.self, from: data)

            let ingredients = temp.ingredients.map { ingredient -> IngredientLite in
                var newIngredient = ingredient
                if ingredient.unit == "kg", let quantity = ingredient.quantity, quantity < 1 {
                    newIngredient.quantity = quantity * 1000
                    newIngredient.unit = "gram"
                }
                return newIngredient
            }

            return Dish(
                id: UUID(),
                name: temp.name,
                description: nil,
                image: nil,
                recipe: nil,
                ingredients: ingredients,
                nutritionFacts: temp.nutritionFacts
            )
        } catch {
            print("Parse error: \(error)")
            return nil
        }
    }

}

struct GeminiDishResponse: Codable {
    let name: String
    let ingredients: [IngredientLite]
    let nutritionFacts: NutritionFacts?
}

 //Save / Load Image to Documents
func saveImageToDocuments(_ image: UIImage, withName name: String) -> String? {
    guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
    let filename = "\(UUID().uuidString).jpg"
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
    
    do {
        try data.write(to: url)
        return filename // chỉ lưu tên file
    } catch {
        print("Lưu ảnh thất bại: \(error)")
        return nil
    }
}

func loadImageFromDocuments(named name: String) -> UIImage? {
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(name)
    return UIImage(contentsOfFile: url.path)
}
