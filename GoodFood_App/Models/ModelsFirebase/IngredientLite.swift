//
//  IngredientLite.swift
//  GoodFood_App
//
//  Created by Guest User on 2/7/25.
//

import Foundation

struct IngredientLite: Codable, Hashable {
    var id: UUID = .init()
    var name: String
    var unit: String?
    var state: String?
    var quantity: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, unit, state, quantity
    }

    init(id: UUID = UUID(), name: String, unit: String? = nil, state: String? = nil, quantity: Double? = nil) {
        self.id = id
        self.name = name
        self.unit = unit
        self.state = state
        self.quantity = quantity
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(UUID.self, forKey: .id)) ?? UUID() // Nếu không có id thì tự gán mới
        self.name = try container.decode(String.self, forKey: .name)
        self.unit = try? container.decode(String.self, forKey: .unit)
        self.state = try? container.decode(String.self, forKey: .state)
        self.quantity = try? container.decode(Double.self, forKey: .quantity)
    }
}
