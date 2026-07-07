//
//  NotifiModel.swift
//  GoodFood_App
//
//  Created by Guest User on 15/7/25.
//

import SwiftUI

struct NotifiModel: Codable, Identifiable {
    var id: UUID
    var title: String?
    var content: String?
    var dateTime: Date?
}
