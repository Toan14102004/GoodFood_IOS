//
//  ProcessData.swift
//  GoodFood_App
//
//  Created by Guest User on 4/8/25.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Foundation


class ProcessData: ObservableObject {
    
    @StateObject var firebaseService = FirebaseService()
    @State private var date: Date = Date()

    @Published var kcalIn: Double = 0
    @Published var kcalOut: Double = 2000
    @Published var fat: Double = 0
    @Published var carbs: Double = 0
    @Published var protein: Double = 0

    var userID: String {
        Auth.auth().currentUser?.uid ?? "default_user"
    }

    func saveNutritionSummariesToCoreData() {
        firebaseService.fetchAllNutritionSummaries(userId: userID) { result in
            switch result {
            case .success(let summaries):
                DispatchQueue.main.async {
                    for summary in summaries {
                        CoreDataService.shared.saveDailyRecord(
                            date: summary.date ?? Date(),
                            kcalIn: summary.calories ?? 0,
                            kcalOut: 0,
                            carbs: summary.carbohydrates ?? 0,
                            protein: summary.protein ?? 0,
                            fat: summary.fat ?? 0
                        )
                    }
                }

            case .failure(let error):
                print("Lỗi khi lấy dữ liệu tổng ngày: \(error)")
            }
        }
    }
    
    func printAllDailyRecords() {
        let records = CoreDataService.shared.fetchAllDailyRecords()
        for record in records {
            print("Ngày: \(record.date ?? Date())")
            print("kcalIn: \(record.kcalIn)")
            print("kcalOut: \(record.kcalOut)")
            print("carbs: \(record.carbs)")
            print("protein: \(record.protein)")
            print("fat: \(record.fat)")
        }
    }
}
