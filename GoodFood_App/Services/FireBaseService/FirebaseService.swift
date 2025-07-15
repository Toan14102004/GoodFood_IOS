//
//  FirebaseService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirebaseService: ObservableObject {
    @Published var dailyRecord: DailyRecord?
    @Published var dishHistory: [Dish] = []
    @EnvironmentObject var authViewModel: AuthViewModel
    let db = Firestore.firestore()

    var userID: String {
        Auth.auth().currentUser?.uid ?? "default_user"
    }

    func dailyRecordRef(for date: Date) -> DocumentReference {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateID = formatter.string(from: date)
        return db.collection("User").document(userID).collection("dailyRecord").document(dateID)
    }

    func addDishToToday(_ dish: Dish, calories: Double, protein: Double, carbs: Double, fat: Double, nutritionFacts: [String: Any]? = nil, completion: @escaping (Result<Void, Error>) -> Void) {
        let todayRef = dailyRecordRef(for: Date())

        var dishData: [String: Any] = [
            "id": dish.id.uuidString,
            "name": dish.name,
            "description": dish.description,
            "image": dish.image ?? "",
            "recipe": dish.recipe ?? "",
            "ingredients": (dish.ingredients ?? []).map { ingredient in
                [
                    "name": ingredient.name,
                    "unit": ingredient.unit ?? "",
                    "state": ingredient.state ?? "",
                    "quantity": ingredient.quantity
                ]
            }
        ]

        // Thêm nutritionFacts
        if let facts = nutritionFacts {
            for (key, value) in facts {
                dishData[key] = value
            }
        }

        todayRef.collection("dishes").addDocument(data: dishData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }

            // Cập nhật tổng chất cho ngày
            todayRef.setData([
                "date": Timestamp(date: Date()),
                "kcalIn": FieldValue.increment(calories),
                "protein": FieldValue.increment(protein),
                "carbs": FieldValue.increment(carbs),
                "fat": FieldValue.increment(fat)
            ], merge: true)

            //  Thêm vào dishHistory
            var historyDishData = dishData
            historyDishData["calories"] = calories
            historyDishData["protein"] = protein
            historyDishData["carbs"] = carbs
            historyDishData["fat"] = fat
            historyDishData["dateTime"] = Timestamp(date: Date())

            self.db
                .collection("User")
                .document(self.userID)
                .collection("dishHistory")
                .addDocument(data: historyDishData) { err in
                    if let err = err {
                        completion(.failure(err))
                    } else {
                        completion(.success(()))
                    }
                }
        }
    }

    func saveUserInfoToFirebase(user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("User").document(userID)

        var data: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "displayName": user.displayName ?? "",
            "photoURL": user.photoURL ?? "",
            "age": user.age ?? 0,
            "sex": user.sex ?? false,
            "height": user.height ?? 0.0,
            "weight": user.weight ?? 0.0,
            "targetWeight": user.targetWeight ?? 0.0,
            "weighHistory": user.weighHistory ?? []
        ]

        userRef.setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func updateUserInforToFirebase(_ user: UserModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("User").document(userID)

        let data: [String: Any] = [
            "email": user.email,
            "displayName": user.displayName ?? "",
            "photoURL": user.photoURL ?? "",
            "age": user.age ?? 0,
            "sex": user.sex ?? false,
            "height": user.height ?? 0.0,
            "weight": user.weight ?? 0.0,
            "targetWeight": user.targetWeight ?? 0.0,
            "weighHistory": user.weighHistory ?? []
        ]

        userRef.updateData(data) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }

    func fetchInforUser(authViewModel: AuthViewModel, completion: @escaping (Result<UserModel, Error>) -> Void) {
        let userRef = db.collection("User").document(userID)

        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists, let data = document.data() else {
                completion(.failure(NSError(domain: "Không tìm thấy dữ liệu user", code: 404)))
                return
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let decodedUser = try JSONDecoder().decode(UserModel.self, from: jsonData)

                DispatchQueue.main.async {
                    authViewModel.user = decodedUser
                }

                completion(.success(decodedUser))
            } catch {
                completion(.failure(error))
            }
        }
    }

//    func fetchUserInfo(authViewModel: AuthViewModel) async throws -> UserModel {
//        let userRef = db.collection("User").document(userID)
//        let document = try await userRef.getDocument()
//
//        guard document.exists, let data = document.data() else {
//            throw NSError(domain: "Không tìm thấy dữ liệu user", code: 404)
//        }
//
//        let jsonData = try JSONSerialization.data(withJSONObject: data)
//        let decodedUser = try JSONDecoder().decode(UserModel.self, from: jsonData)
//
//        // Cập nhật UI → bắt buộc DispatchQueue.main.async
//        DispatchQueue.main.async {
//            authViewModel.user = decodedUser
//        }
//
//        return decodedUser
//    }

    func calculateKcalOut(from user: UserModel, activityLevel: Double = 1.375) -> Double {
        guard let age = user.age,
              let height = user.height,
              let weight = user.weight,
              let isMale = user.sex
        else {
            return 2000
        }

        let bmr: Double
        if isMale {
            bmr = 10 * weight + 625 * height - 5 * Double(age) + 5
        } else {
            bmr = 10 * weight + 625 * height - 5 * Double(age) - 161
        }

        let tdee = bmr * activityLevel
        return tdee
    }
    
    func fetchDataOfDay(date: Date, completion: @escaping (Result<[Dish], Error>) -> Void) {
        let dayRef = dailyRecordRef(for: date)

        dayRef.collection("dishes").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([])) // Không có món ăn nào trong ngày
                return
            }

            let dishes: [Dish] = documents.compactMap { doc -> Dish? in
                let data = doc.data()
                guard let idString = data["id"] as? String,
                      let id = UUID(uuidString: idString)
                else {
                    return nil
                }
                let name = data["name"] as? String
                let description = data["description"] as? String
                let image = data["image"] as? String
                let recipe = data["recipe"] as? String

                // Parse ingredients
                let ingredientsArray = data["ingredients"] as? [[String: Any]]
                let ingredients: [IngredientLite]? = ingredientsArray?.compactMap { item in
                    guard let name = item["name"] as? String else { return nil }
                    return IngredientLite(
                        name: name,
                        unit: item["unit"] as? String,
                        state: item["state"] as? String,
                        quantity: item["quantity"] as? Double
                    )
                }

                // Parse nutritionFacts
                var nutritionFacts: NutritionFacts?
                if let kcal = data["calories"] as? Double,
                   let protein = data["protein"] as? Double,
                   let carbs = data["carbs"] as? Double,
                   let fat = data["fat"] as? Double
                {
                    nutritionFacts = NutritionFacts(calories: kcal, fat: fat, protein: protein, carbohydrates: carbs)
                }

                return Dish(
                    id: id,
                    name: name,
                    description: description,
                    image: image,
                    recipe: recipe,
                    ingredients: ingredients,
                    nutritionFacts: nutritionFacts
                )
            }
            completion(.success(dishes))
        }
    }

    func fetchNutritionSummary(for date: Date, completion: @escaping (Result<NutritionFacts, Error>) -> Void) {
        let dayRef = dailyRecordRef(for: date)

        dayRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = snapshot?.data() else {
                // Không có dữ liệu, trả về NutritionFacts = 0
                let emptySummary = NutritionFacts(calories: 0, fat: 0, protein: 0, carbohydrates: 0)
                completion(.success(emptySummary))
                return
            }

            let calories = data["kcalIn"] as? Double ?? 0
            let protein = data["protein"] as? Double ?? 0
            let carbs = data["carbs"] as? Double ?? 0
            let fat = data["fat"] as? Double ?? 0

            let summary = NutritionFacts(
                calories: calories,
                fat: fat,
                protein: protein,
                carbohydrates: carbs
            )
            completion(.success(summary))
        }
    }

    func fetchTargetWeight() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in //cách Swift "bọc" callback-based API (như Firebase) thành async
            db.collection("User").document(userID).getDocument { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let data = snapshot?.data() else {
                    continuation.resume(returning: "0")
                    return
                }

                let targetWeight = data["targetWeight"] as? Double ?? 0
                let stringValue = String(format: "%.1f", targetWeight)
                continuation.resume(returning: stringValue)
            }
        }
    }

    func fetchCurrentWeight() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            db.collection("User").document(userID).getDocument { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let data = snapshot?.data() else {
                    continuation.resume(returning: "0")
                    return
                }

                let currentWeight = data["weight"] as? Double ?? 0
                let stringValue = String(format: "%.1f", currentWeight)
                continuation.resume(returning: stringValue)
            }
        }
    }


    func fetchDailyKcalSummary(completion: @escaping (Result<[KcalEntry], Error>) -> Void) {
        db.collection("User").document(userID).collection("dailyRecord").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            // Ngày hôm nay và 6 ngày trước
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            guard let startDate = calendar.date(byAdding: .day, value: -6, to: today) else {
                completion(.success([]))
                return
            }

            var entries: [KcalEntry] = []

            for document in documents {
                let docID = document.documentID
                guard let date = formatter.date(from: docID) else { continue }

                // Chỉ lấy các ngày trong khoảng [startDate, today]
                if date >= startDate && date <= today {
                    let data = document.data()
                    let kcal = Int(data["kcalIn"] as? Double ?? 0)
                    entries.append(KcalEntry(date: date, kcal: kcal))
                }
            }

            // Sắp xếp theo ngày tăng dần
            let sortedEntries = entries.sorted { $0.date < $1.date }

            completion(.success(sortedEntries))
        }
    }

    func fetchWeightHistory(completion: @escaping (Result<[Double], Error>) -> Void) {
        db.collection("User").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = document, document.exists,
                  let data = document.data(),
                  let weights = data["weighHistory"] as? [Double]
            else {
                completion(.success([])) // Trả về mảng rỗng nếu không có dữ liệu
                return
            }

            completion(.success(weights))
        }
    }

    func fetchDishHistory(completion: @escaping (Result<[Dish], Error>) -> Void) {
        db.collection("User").document(userID).collection("dishHistory").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let dishes: [Dish] = documents.compactMap { document in
                var data = document.data()

                // Convert Timestamp to String for decoding
                if let timestamp = data["dateTime"] as? Timestamp {
                    let date = timestamp.dateValue()
                    let formatter = ISO8601DateFormatter()
                    data["dateTime"] = formatter.string(from: date)
                }

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    var dish = try JSONDecoder().decode(Dish.self, from: jsonData)

                    // Convert String back to Date
                    if let dateTimeString = data["dateTime"] as? String {
                        let formatter = ISO8601DateFormatter()
                        dish.dateTime = formatter.date(from: dateTimeString)
                    }

                    // Parse nutritionFacts theo dữ liệu thực tế Firebase
                    let calories = data["calories"] as? Double ?? 0
                    let fat = data["fat"] as? Double ?? 0
                    let saturatedFat = data["saturatedFat"] as? Double ?? 0
                    let protein = data["protein"] as? Double ?? 0
                    let carbohydrates = data["carbs"] as? Double ?? 0
                    let sugar = data["sugar"] as? Double ?? 0
                    let fiber = data["fiber"] as? Double ?? 0
                    let cholesterol = data["cholesterol"] as? Double ?? 0
                    let sodium = data["sodium"] as? Double ?? 0
                    let calcium = data["calcium"] as? Double ?? 0
                    let iron = data["iron"] as? Double ?? 0
                    let potassium = data["potassium"] as? Double ?? 0

                    dish.nutritionFacts = NutritionFacts(
                        calories: calories,
                        fat: fat,
                        saturatedFat: saturatedFat,
                        protein: protein,
                        carbohydrates: carbohydrates,
                        sugar: sugar,
                        fiber: fiber,
                        cholesterol: cholesterol,
                        sodium: sodium,
                        calcium: calcium,
                        iron: iron,
                        potassium: potassium
                    )

                    return dish
                } catch {
                    print("Lỗi parse dish: \(error)")
                    return nil
                }
            }

            completion(.success(dishes))
        }
    }

    func uploadDishImage(_ image: UIImage, imageName: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không thể nén ảnh"])))
            return
        }

        let storageRef = Storage.storage().reference().child("dish_images/\(imageName)")

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let url = url else {
                    completion(.failure(NSError(domain: "DownloadURLError", code: 0, userInfo: nil)))
                    return
                }
                print("Đã lấy được downloadURL:", url.absoluteString)
                completion(.success(url))
            }
        }
    }
}
