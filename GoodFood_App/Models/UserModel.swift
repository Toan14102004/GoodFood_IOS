//
//  UserModel.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation

struct UserModel: Identifiable {
    var id: String
    var email: String
    var displayName: String?
    var photoURL: String?
    var sex : Bool?
    var height : Double?
    var weight : Double?
    var age : Int?
    
    init(id: String, email: String, displayName: String? = nil, photoURL: String? = nil, sex: Bool? = nil, height: Double? = nil, weight: Double? = nil, age: Int? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.sex = sex
        self.height = height
        self.weight = weight
        self.age = age
    }
}

