//
//  UserModel.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation

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
    var weighHistory: [Double]?
}
