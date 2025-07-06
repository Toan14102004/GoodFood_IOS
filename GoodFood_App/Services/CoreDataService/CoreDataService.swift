//
//  CoreDataService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.

import CoreData
import Foundation

struct WeightRecord: Codable {
    let date: Date
    let weight: Double
}

class CoreDataService {
    static let shared = CoreDataService()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "GoodFood_App")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Lỗi load Core Data: \(error.localizedDescription)")
            }
        }
    }

    func saveUser(_ user: UserModel) {
        let context = container.viewContext

        // Kiểm tra đã có user trong Core Data chưa (dựa vào id)
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            let entity: UserEntity

            if let existingUser = results.first {
                // Nếu đã có → cập nhật
                entity = existingUser
            } else {
                // Nếu chưa có → thêm mới
                entity = UserEntity(context: context)
                entity.id = user.id
            }

            entity.email = user.email
            entity.displayName = user.displayName
            entity.photoURL = user.photoURL
            entity.sex = user.sex ?? false
            entity.height = user.height ?? 0.0
            entity.weight = user.weight ?? 0.0
            entity.targetWeight = user.targetWeight ?? 0.0
            entity.age = Int32(user.age ?? 0)
            if let weighHistory = user.weighHistory {
                do {
                    let encoded = try JSONEncoder().encode(weighHistory)
                    entity.weighHistory = encoded
                } catch {
                    print("Lỗi khi encode weighHistory: \(error.localizedDescription)")
                }
            }

            saveContext()
            
            print("Đã lưu user:")
            print("ID: \(entity.id ?? "nil")")
            print("Email: \(entity.email ?? "nil")")
            print("Display Name: \(entity.displayName ?? "nil")")
            print("Photo URL: \(entity.photoURL ?? "nil")")
            print("Giới tính: \(entity.sex)")
            print("Chiều cao: \(entity.height)")
            print("Cân nặng: \(entity.weight)")
            print("Mục tiêu cân nặng: \(entity.targetWeight)")
            print("Tuổi: \(entity.age)")

            if let weighHistoryData = entity.weighHistory,
               let history = try? JSONDecoder().decode([WeightRecord].self, from: weighHistoryData) {
                print("Lịch sử cân nặng:")
                for record in history {
                    print(" - \(record.date): \(record.weight) kg")
                }
            } else {
                print("Không có lịch sử cân nặng")
            }

            
        } catch {
            print("Lỗi khi lưu user vào Core Data: \(error.localizedDescription)")
        }
    }
    
    //func updateInforUser(_ user: UserModel){

    func fetchUser() -> (UserEntity?, [WeightRecord]?) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            if let user = try container.viewContext.fetch(request).first {
                if let data = user.weighHistory,
                   let history = try? JSONDecoder().decode([WeightRecord].self, from: data)
                {
                    return (user, history)
                }
                return (user, nil)
            }
        } catch {
            print("Lỗi fetch User: \(error.localizedDescription)")
        }
        return (nil, nil)
    }

    func saveDailyRecord(date: Date, kcalIn: Double, kcalOut: Double, carbs: Double, protein: Double, fat: Double) {
        let context = container.viewContext
        let record = DailyRecordEntity(context: context)
//        record.id = UUID()

        record.date = date
        record.kcalIn = kcalIn
        record.kcalOut = kcalOut
        record.carbs = carbs
        record.protein = protein
        record.fat = fat
        saveContext()
    }

    func fetchAllDailyRecords() -> [DailyRecordEntity] {
        let request: NSFetchRequest<DailyRecordEntity> = DailyRecordEntity.fetchRequest()
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print(" Lỗi fetch Daily Records: \(error.localizedDescription)")
            return []
        }
    }

    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(" Lỗi save context: \(error.localizedDescription)")
            }
        }
    }
}
