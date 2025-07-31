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
