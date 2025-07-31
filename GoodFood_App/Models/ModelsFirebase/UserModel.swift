//
//  UserModel.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
//,Identifiable
import FirebaseFirestore
import Foundation

struct WeightRecord: Codable {
    var date: Date
    var weight: Double

    init() {
        date = Date()
        weight = 40
    }

    init(weight: Double) {
        date = Date()
        self.weight = weight
    }

    init(date: Date, weight: Double) {
        self.date = date
        self.weight = weight
    }

    func toDict() -> [String: Any] {
        return [
            "date": self.date,
            "weight": self.weight
        ]
    }

    func fromDict(_ dict: [String: Any]) -> WeightRecord? {
        guard
            let timestamp = dict["date"] as? Timestamp,
            let weight = dict["weight"] as? Double
        else {
            return nil
        }
        return WeightRecord(date: timestamp.dateValue(), weight: weight)
    }

}

struct UserModel: Identifiable, Codable {
    var id: String
    var email: String
    var displayName: String?
    var photoURL: String?
    var sex: Bool?
    var height: Double?
    var weight: Double?
    var targetWeight: Double?
    var age: Int?
    var weighHistory: [WeightRecord]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        photoURL = try container.decodeIfPresent(String.self, forKey: .photoURL)
        sex = try container.decodeIfPresent(Bool.self, forKey: .sex)
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        targetWeight = try container.decodeIfPresent(Double.self, forKey: .targetWeight)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        weighHistory = try container.decodeIfPresent([WeightRecord].self, forKey: .weighHistory)
    }

    init() {
        id = "123"
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

    init(id: String, email: String, displayName: String? = nil, photoURL: String? = nil, sex: Bool? = nil, height: Double? = nil, weight: Double? = nil, targetWeight: Double? = nil, age: Int? = nil, weighHistory: [WeightRecord]? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.sex = sex
        self.height = height
        self.weight = weight
        self.targetWeight = targetWeight
        self.age = age
        self.weighHistory = weighHistory
    }

    init(id: String, email: String, displayName: String? = nil, photoURL: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
    }
}
