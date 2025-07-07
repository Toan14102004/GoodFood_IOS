//
//  DishHistoryEntity.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//

//import CoreData
//import Foundation
//
//@objc(DishHistoryEntity)
//class DishHistoryEntity: NSManagedObject {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<DishHistoryEntity> {
//        NSFetchRequest<DishHistoryEntity>(entityName: "DishHistoryEntity")
//    }
//
//    @NSManaged public var id: UUID?
//    @NSManaged public var dateTime: Date?
//    // Dạng Transformable: lưu dưới dạng Data (đã encode từ struct)
//    @NSManaged public var ingredients: Data?
//    @NSManaged public var nutritionFacts: Data?
//
//    // Quan hệ: to-one đến entity Dish
//    @NSManaged public var dish: DishEntity?
//}
