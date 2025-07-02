//
//  dailyRecord.swift
//  GoodFood_App
//
//  Created by Guest User on 1/7/25.
//
import Foundation

struct DailyRecord: Identifiable, Codable {
    var id: String // yyyyMMdd
    var date: Date
    var kcalIn: Double
    var kcalOut: Double
    var carbs: Double
    var fat: Double
    var protein: Double
    var dishes: [String: DishLite]
}
