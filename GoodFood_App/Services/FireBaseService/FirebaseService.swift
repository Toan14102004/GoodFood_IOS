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
    @Published var dailyRecords: [DailyRecord] = []
    let db = Firestore.firestore()

    var userID: String {
        Auth.auth().currentUser?.uid ?? "default_user"
    }

    var dailyRecordOfUser: CollectionReference {
        db.collection("User")
            .document(userID)
            .collection("dailyRecord")
    }

//    func addDish(_Dish: Dish) {
//        dailyRecordOfUser.document(savedDish.id).setData(savedDish.toDict(), merge: true) { error in
//            if let error = error {
//                print("Lỗi thêm món ăn lên Firebase: \(error.localizedDescription)")
//            } else {
//                print("Đã thêm món ăn lên Firebase: \(savedDish.title)")
//            }
//        }
//    }
}
