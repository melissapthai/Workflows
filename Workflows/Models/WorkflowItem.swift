//
//  WorkflowItem.swift
//  Workflows
//
//  Created by Melissa Thai on 10/8/22.
//

import SwiftUI

enum WorkflowItemCodingKeys: CodingKey {
    case id, value
}

class WorkflowItem: Identifiable, Codable, ObservableObject {
    let id: String
    @Published var value: String

    init() {
        self.id = UUID().uuidString
        self.value = ""
    }

    init(value: String) {
        self.id = UUID().uuidString
        self.value = value
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WorkflowItemCodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.value = try container.decode(String.self, forKey: .value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WorkflowItemCodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.value, forKey: .value)
    }
}
