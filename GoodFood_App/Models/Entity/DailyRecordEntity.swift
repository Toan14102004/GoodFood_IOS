//
//  DailyRecordEntity.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//

import CoreData
import Foundation

@objc(DailyRecordEntity)
class DailyRecordEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyRecordEntity> {
        NSFetchRequest<DailyRecordEntity>(entityName: "DailyRecordEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var kcalIn: Double
    @NSManaged public var kcalOut: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fat: Double
    @NSManaged public var protein: Double
}
