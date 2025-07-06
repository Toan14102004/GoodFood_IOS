//
//  GerminiService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation

class GeminiService {
    static let shared = GeminiService()
    //var user: UserModel
    
    private let apiKey = "AIzaSyD4lET4epcDKH9t0CqVn36qBki-tXIYi7g"
    private let modelName = "gemini-1.5-flash"
//    private init(user : UserModel = .init()){
//        return self.user = user
//    }

    private func generateText(from prompt: String, completion: @escaping (String?) -> Void) {
        let urlString = "https://generativelanguage.googleapis.com/v1/models/\(modelName):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion("URL không hợp lệ")
            return
        }

        let requestData: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            completion("Lỗi JSON: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion("Lỗi kết nối: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion("Không nhận được dữ liệu")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let candidates = json?["candidates"] as? [[String: Any]],
                   let content = candidates.first?["content"] as? [String: Any],
                   let parts = content["parts"] as? [[String: Any]],
                   let text = parts.first?["text"] as? String {
                    completion(text)
                } else {
                    completion("Không thể phân tích phản hồi")
                }
            } catch {
                completion("Lỗi khi phân tích JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    func analyzeMood(from diaryText: String, completion: @escaping (String?, [String]?, String?, [String]?, String?) -> Void) {
        let prompt = """
        Bạn là một chuyên gia tâm lý học. Hãy phân tích đoạn tâm sự của người dùng dưới góc nhìn cảm xúc.

        Đầu ra phải trả về đúng JSON định dạng như sau (rất quan trọng):
        {
          "mood": "tâm trạng chính",
          "emotions": ["danh sách cảm xúc"],
          "advice": "lời khuyên phù hợp với tâm trạng",
          "suggestedActivities": ["hoạt động 1", "hoạt động 2", ...]
        }

        Phân tích đoạn sau:
        \"\(diaryText)\"
        """

        generateText(from: prompt) { responseText in
            guard let responseText = responseText else {
                completion(nil, nil, nil, nil, "Không có phản hồi từ AI")
                return
            }

            guard let jsonStart = responseText.firstIndex(of: "{"),
                  let jsonEnd = responseText.lastIndex(of: "}") else {
                completion(nil, nil, nil, nil, "Không tìm thấy JSON trong phản hồi")
                return
            }

            let jsonString = String(responseText[jsonStart...jsonEnd])

            guard let data = jsonString.data(using: .utf8) else {
                completion(nil, nil, nil, nil, "Không thể chuyển JSON thành Data")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let mood = json["mood"] as? String
                    let emotions = json["emotions"] as? [String]
                    let advice = json["advice"] as? String
                    let activities = json["suggestedActivities"] as? [String]
                    completion(mood, emotions, advice, activities, nil)
                } else {
                    completion(nil, nil, nil, nil, "Phản hồi không phải JSON")
                }
            } catch {
                completion(nil, nil, nil, nil, "❌ Lỗi khi đọc JSON: \(error.localizedDescription)\nJSON: \(jsonString)")
            }
        }
    }
}

