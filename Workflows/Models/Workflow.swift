//
//  Workflow.swift
//  Workflows
//
//  Created by Melissa Thai on 10/8/22.
//

import SwiftUI

enum WorkflowCodingKeys: CodingKey {
    case id, items
}

class Workflow: Identifiable, Codable, ObservableObject {
    let id: String
    @Published var items: [WorkflowItem]

    init() {
        self.id = UUID().uuidString
        self.items = []
    }

    init(items: [WorkflowItem]) {
        self.id = UUID().uuidString
        self.items = items
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WorkflowCodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.items = try container.decode([WorkflowItem].self, forKey: .items)
    }

    func launchWorkflow() {
        for item in self.items {
            if let url = URL(string: item.value) {
                NSWorkspace.shared.open(url)
            } else {
                print("Unable to open \(item.value)")
            }
        }
    }

    func addWorkflowItem(item: WorkflowItem) {
        self.items.append(item)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WorkflowCodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.items, forKey: .items)
    }
}
