//
//  UserEntity.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import CoreData
import Foundation

@objc(UserEntity)
class UserEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
//    @NSManaged public var id: UUID?
    @NSManaged public var email: String?
    @NSManaged public var displayName: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var sex: Bool
    @NSManaged public var height: Double
    @NSManaged public var weight: Double
    @NSManaged public var targetWeight: Double
    @NSManaged public var age: Int32
    @NSManaged public var weighHistory: Data?
}
