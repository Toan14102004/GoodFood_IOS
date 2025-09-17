//
//  GerminiService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

// guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=\(apiKey)"),
//apikey = "AIzaSyCzM7Y2O8ITNa0_FSnx8E3rbDByLkLZ1tI"
//

import Foundation
import UIKit

class GeminiService {
    static let shared = GeminiService()
    private init() {}
//    private let apiKey = "AIzaSyBDoz2u6D7uHBqsI0vcJifP0s9lNqB_llw"
    private let apiKey = "AIzaSyCzM7Y2O8ITNa0_FSnx8E3rbDByLkLZ1tI"
    private var geminiEndpointURL: URL? {
        return URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent?key=\(apiKey)")
    }

    // Public Suggestion API

    func suggestion(text1: String, text2: String, retryCount: Int = 3, completion: @escaping (Result<[DishSuggestion], Error>) -> Void) {
        let requestData = makeSuggestionBodyParam(text1: text1, text2: text2)

        guard let url = geminiEndpointURL,

              let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        else {
            completion(.failure(NSError(domain: "URLSerializationError", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        // URLSession gửi request bất đồng bộ
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }

            print("Suggestion Response: \(String(data: data, encoding: .utf8) ?? "N/A")")

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                if let error = json?["error"] as? [String: Any],
                   let message = error["message"] as? String
                {
                    completion(.failure(NSError(domain: "GeminiAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])))
                    return
                }

                guard let candidates = json?["candidates"] as? [[String: Any]],
                      let content = candidates.first?["content"] as? [String: Any],
                      let parts = content["parts"] as? [[String: Any]],
                      let text = parts.first?["text"] as? String
                else {
                    completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: nil)))
                    return
                }

                let cleanedText = text
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                guard let resultData = cleanedText.data(using: .utf8) else {
                    completion(.failure(NSError(domain: "InvalidData", code: 0, userInfo: nil)))
                    return
                }

                let dishes = try JSONDecoder().decode([DishSuggestion].self, from: resultData)
                completion(.success(dishes))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func suggestionAsync(text1: String, text2: String) async throws -> [DishSuggestion] {
        try await withCheckedThrowingContinuation { continuation in
            self.suggestion(text1: text1, text2: text2) { result in
                continuation.resume(with: result)
            }
        }
    }

    // MARK: - Public Image Detection API

    func detectDishAndIngredients(from image: UIImage, retryCount: Int = 3, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không thể nén ảnh"])))
            return
        }

        let base64Image = imageData.base64EncodedString()
        let requestData = makeImageAnalysisBodyParam(base64Image: base64Image)

        guard let url = geminiEndpointURL,
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
                   let message = error["message"] as? String
                {
                    print("Lỗi Gemini: \(message)")
                    if message.contains("overloaded"), retryCount > 0 {
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
                      let text = parts.first?["text"] as? String
                else {
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

    // MARK: - Helper: Parse JSON to Model

    func parseDish(from geminiResponse: String) -> Dish? {
        let cleanResponse = geminiResponse
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleanResponse.data(using: .utf8) else { return nil }

        do {
            let temp = try JSONDecoder().decode(GeminiDishResponse.self, from: data)

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

    // tính toán dinh dưỡng từ Dish
    func analyzeNutrition(for dish: Dish, completion: @escaping (Result<NutritionFacts, Error>) -> Void) {
        let requestData = makeNutritionAnalysisBodyParam(from: dish)

        guard let url = geminiEndpointURL,
              let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        else {
            completion(.failure(NSError(domain: "SerializationError", code: 0, userInfo: nil)))
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

            print("Nutrition Response: \(String(data: data, encoding: .utf8) ?? "N/A")")

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let candidates = json?["candidates"] as? [[String: Any]],
                      let content = candidates.first?["content"] as? [String: Any],
                      let parts = content["parts"] as? [[String: Any]],
                      let text = parts.first?["text"] as? String
                else {
                    completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: nil)))
                    return
                }

                let cleaned = text
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                guard let jsonData = cleaned.data(using: .utf8) else {
                    completion(.failure(NSError(domain: "InvalidJSON", code: 0, userInfo: nil)))
                    return
                }

                let result = try JSONDecoder().decode(NutritionFacts.self, from: jsonData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // MARK: - Private Helpers (Tách JSON body)

    private func makeImageAnalysisBodyParam(base64Image: String) -> [String: Any] {
        return [
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
    }

    private func makeSuggestionBodyParam(text1: String, text2: String) -> [String: Any] {
        return [
            "contents": [
                [
                    "parts": [
                        ["text": """
                        Gợi ý 10 món ăn giúp đạt được mục tiêu cân nặng là \(text1) kg, với cân nặng hiện tại \(text2) kg.
                        Trả lời bằng JSON, đúng format sau:
                        [
                          {
                            "name": "Tên món ăn",
                            "ingredients": [
                              { "name": "Tên nguyên liệu", 
                                "quantity": số thập phân **dạng số thực**, không dùng phân số như "1/2", phải là ví dụ như: 0.5, 1.0, 150.0,
                                "unit": "đơn vị" }
                            ],
                            "recipe": "Cách chế biến chi tiết",
                            "nutritionFacts": {
                              "calories": số,
                              "protein": số,
                              "carbohydrates": số,
                              "fat": số
                            }
                          }
                        ]
                        Không Markdown, không ký hiệu thừa, trả lời bằng tiếng Việt, đúng JSON.
                        """]
                    ]
                ]
            ]
        ]
    }

    // Phân tích dinh dưỡng từ món ăn User đưa
    func makeNutritionAnalysisBodyParam(from dish: Dish) -> [String: Any] {
        let ingredientDescriptions: String = (dish.ingredients ?? []).map { ingredient in
            let quantityText = ingredient.quantity != nil ? "\(ingredient.quantity!)" : "không rõ"
            let unitText = ingredient.unit ?? "đơn vị không rõ"
            let stateText = ingredient.state ?? "không rõ trạng thái"
            return "- \(ingredient.name): \(quantityText) \(unitText), trạng thái: \(stateText)"
        }.joined(separator: "\n")

        let dishName = dish.name ?? "Không rõ tên món"

        let promptText = """
        Hãy phân tích thành phần dinh dưỡng ước lượng cho món ăn sau:

        Tên món: \(dishName)

        Nguyên liệu:
        \(ingredientDescriptions)

        Trả lời bằng tiếng Việt, chỉ đúng JSON, không có Markdown, không có ký hiệu thừa. Format như sau:
        {
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

        Nếu không đủ thông tin, hãy ước lượng dựa trên kiến thức dinh dưỡng phổ biến.
        """

        return [
            "contents": [
                [
                    "parts": [
                        ["text": promptText]
                    ]
                ]
            ]
        ]
    }
}

// MARK: - Models

// struct GeminiDishResponse: Codable {
//    let name: String
//    let ingredients: [IngredientLite]
//    let nutritionFacts: NutritionFacts?
// }
//
// struct DishSuggestion: Codable {
//    let name: String
//    let ingredients: [IngredientLite]
//    let description: String?
//    let recipe: String
//    let nutritionFacts: NutritionFacts
// }
