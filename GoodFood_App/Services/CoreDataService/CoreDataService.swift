//
//  CoreDataService.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
// if let data = entity.weighHistory {
//    let history = try? JSONDecoder().decode([WeightRecord].self, from: data)
// }

import CoreData
import Foundation

class CoreDataService {
    static let shared = CoreDataService()
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "GoodFood_App")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Lỗi load Core Data: \(error.localizedDescription)")
            }
        }
        print("Đang dùng dữ liệu từ Core Data: \(container)")
    }

    // Save context
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(" Lỗi khi lưu context: \(error)")
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

//            if var weighHistory = user.weighHistory, var weightUser = user.weight {
//                weighHistory.append(WeightRecord(weight: weightUser) ?? WeightRecord())
            if var weighHistory = user.weighHistory, let weightUser = user.weight {
                let newRecord = WeightRecord(weight: weightUser)
                // Chỉ thêm nếu khác bản ghi gần nhất (tránh trùng)
                if weighHistory.last?.weight != newRecord.weight ||
                    abs((weighHistory.last?.date.timeIntervalSince(newRecord.date) ?? 9999)) > 60
                {
                    weighHistory.append(newRecord)
                }

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
               let history = try? JSONDecoder().decode([WeightRecord].self, from: weighHistoryData)
            {
                print("Lịch sử cân nặng:")
                for record in history {
                    print(" - \(record.date): \(record.weight) kg")
                }
            } else {
                print("Không có lịch sử cân nặng khi lưu")
            }
        } catch {
            print("Lỗi khi lưu user vào Core Data: \(error.localizedDescription)")
        }
    }

    func hasUserInCoreData() -> Bool {
        return CoreDataService.shared.fetchUserModel() != nil
    }

    func fetchUser() -> (UserEntity?, [WeightRecord]?) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            if let user = try container.viewContext.fetch(request).first {
                print("Đã fetch user lấy cả lsu:")
                print("ID: \(user.id ?? "nil")")
                print("Email: \(user.email ?? "nil")")
                print("Display Name: \(user.displayName ?? "nil")")
                print("Photo URL: \(user.photoURL ?? "nil")")
                print("Giới tính: \(user.sex)")
                print("Chiều cao: \(user.height)")
                print("Cân nặng: \(user.weight)")
                print("Mục tiêu cân nặng: \(user.targetWeight)")
                print("Tuổi: \(user.age)")

                if let data = user.weighHistory,
                   let history = try? JSONDecoder().decode([WeightRecord].self, from: data)
                {
                    print("Lịch sử cân nặng có trong coredaet:")
                    for record in history {
                        print(" - \(record.date): \(record.weight) kg")
                    }
                    return (user, history)
                } else {
                    print("Không có lịch sử cân nặng")
                    return (user, nil)
                }
            } else {
                print("Không tìm thấy user trong Core Data")
            }
        } catch {
            print("Lỗi fetch User: \(error.localizedDescription)")
        }
        return (nil, nil)
    }

    func fetchUserModel() -> UserModel? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            if let user = try container.viewContext.fetch(request).first {
                print("Đã fetch user:")
                print("ID: \(user.id ?? "nil")")
                print("Email: \(user.email ?? "nil")")
                print("Display Name: \(user.displayName ?? "nil")")
                print("Photo URL: \(user.photoURL ?? "nil")")
                print("Giới tính: \(user.sex)")
                print("Chiều cao: \(user.height)")
                print("Cân nặng: \(user.weight)")
                print("Mục tiêu cân nặng: \(user.targetWeight)")
                print("Tuổi: \(user.age)")
                print("Lịch sử cân nặng: \(user.weighHistory)")

                // Chuyển về UserModel
                var weightHistory: [WeightRecord]?
                if let historyData = user.weighHistory {
                    weightHistory = try? JSONDecoder().decode([WeightRecord].self, from: historyData)
                }

                let userModel = UserModel(
                    id: user.id ?? UUID().uuidString,
                    email: user.email ?? "",
                    displayName: user.displayName,
                    photoURL: user.photoURL,
                    sex: user.sex,
                    height: user.height,
                    weight: user.weight,
                    targetWeight: user.targetWeight,
                    age: Int(user.age),
                    weighHistory: weightHistory
                )

                return userModel
            } else {
                print("Không tìm thấy user trong Core Data")
            }
        } catch {
            print("Lỗi fetch User: \(error.localizedDescription)")
        }
        return nil
    }

    func updateUserInforToCoredata(_ user: UserModel, _ email: String, _ age: Int32, _ sex: Bool, _ height: Double, _ weight: Double) {
        let context = container.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id)

        do {
            if let entity = try context.fetch(request).first {
                entity.email = email
                entity.age = age
                entity.sex = sex
                entity.height = height
                entity.weight = weight
                entity.weighHistory = try? JSONEncoder().encode(user.weighHistory)

                saveContext()
                print(" Đã cập nhật  Core Data: \(email)")
            } else {
                print(" Không tìm thấy để cập nhật.")
            }
        } catch {
            print(" Lỗi cập nhật trong Core Data: \(error)")
        }
    }

    func saveDailyRecord(date: Date, kcalIn: Double, kcalOut: Double, carbs: Double, protein: Double, fat: Double) {
        let context = container.viewContext
        let record = DailyRecordEntity(context: context)

        record.date = date
        record.kcalIn = kcalIn
        record.kcalOut = kcalOut
        record.carbs = carbs
        record.protein = protein
        record.fat = fat

        print("Đã lưu KcalIn vào coredata nghe: \(record.kcalIn) - \(record.carbs)")
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

    func addNutriFood(dish: Dish) {
        let context = container.viewContext
    }
}
