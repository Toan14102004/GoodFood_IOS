//
//  GerminiService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation
import UIKit

class GeminiService {
    private let apiKey = "AIzaSyD4lET4epcDKH9t0CqVn36qBki-tXIYi7g"

    func detectDishAndIngredients(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không thể nén ảnh"])))
            return
        }

        let base64Image = imageData.base64EncodedString()

        let requestData: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": "Hãy phân tích món ăn và nguyên liệu trong ảnh này. Hãy trả lời bằng tiếng Việt."],
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

        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)"),
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
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let candidates = json["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String
                {
                    completion(.success(text))
                } else {
                    completion(.failure(NSError(domain: "ParseError", code: 0, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
