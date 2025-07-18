//
//  UserModel.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation

struct UserModel: Identifiable, Codable {
    var id: String
//    var id: UUID
    var email: String
    var displayName: String?
    var photoURL: String?
    var sex: Bool?
    var height: Double?
    var weight: Double?
    var targetWeight: Double?
    var age: Int?
    var weighHistory: [Double]?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        sex = try container.decodeIfPresent(Bool.self, forKey: .sex)
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        targetWeight = try container.decodeIfPresent(Double.self, forKey: .targetWeight)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        weighHistory = try container.decodeIfPresent([Double].self, forKey: .weighHistory)
    }
    
    init() {
//        id = UUID()
        id = ""
        email = ""
        displayName = nil
        photoURL = nil
        sex = nil
        height = nil
        weight = nil
        targetWeight = nil
        age = nil
        weighHistory = nil
    }
    
    init(id: String, email: String, displayName: String? = nil, photoURL: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
    }
//    init(id: UUID, email: String, displayName: String? = nil, photoURL: String? = nil) {
//            self.id = id
//            self.email = email
//            self.displayName = displayName
//            self.photoURL = photoURL
//        }
}
