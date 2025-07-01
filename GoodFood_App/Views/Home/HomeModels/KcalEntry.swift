//
//  KcalEntry.swift
//  GoodFood_App
//
//  Created by Guest User on 30/6/25.
//
import Charts
import SwiftUI

struct KcalEntry: Identifiable {
    var id = UUID()
    var date: Date
    var kcal: Int
}

let sampleKcalData: [KcalEntry] = [
    KcalEntry(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, kcal: 1500),
    KcalEntry(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, kcal: 1800),
    KcalEntry(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, kcal: 1200),
    KcalEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, kcal: 2000),
    KcalEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, kcal: 1700),
    KcalEntry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, kcal: 1600),
    KcalEntry(date: Date(), kcal: 1900)
]
