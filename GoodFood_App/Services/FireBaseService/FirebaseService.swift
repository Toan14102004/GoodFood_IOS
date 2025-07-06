//
//  FirebaseService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class FirebaseService: ObservableObject {
    @Published var dailyRecord: DailyRecord?
    @Published var dishHistory: [Dish] = []
    @EnvironmentObject var authViewModel : AuthViewModel
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

        // Thêm nutritionFacts nếu có
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
}
