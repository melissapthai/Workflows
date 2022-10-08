//
//  WorkflowsViewModel.swift
//  Workflows
//
//  Created by Melissa Thai on 10/8/22.
//  NOTE: more info on getting/setting to User Defaults: https://stackoverflow.com/questions/62602279/using-appstorage-for-string-map/62602643#62602643

import SwiftUI

enum Focusable: Hashable {
    case id(id: String)
}

class WorkflowsViewModel: ObservableObject {
    @Published var workflows: [Workflow]
    @Published var focusedField: Focusable?
    
    init() {
        self.workflows = []
        let savedWorkflowsData: Data? = UserDefaults.standard.data(forKey: "savedWorkflows")

        if savedWorkflowsData != nil {
            guard let savedWorkflows: [Workflow] = try? JSONDecoder().decode([Workflow].self, from: savedWorkflowsData!) else { return }
            self.workflows = savedWorkflows
        }
    }
    
    init(workflows: [Workflow]) {
        self.workflows = workflows
    }
    
    func createNewWorkflow() {
        let newWorkflow = Workflow()
        let newWorkflowItem = WorkflowItem()
        
        newWorkflow.addWorkflowItem(item: newWorkflowItem)
        
        focusedField = .id(id: newWorkflowItem.id)
        workflows.append(newWorkflow)
        updateSavedWorkflows()
    }
    
    func deleteWorkflow(workflow: Workflow) {
        if let index = workflows.firstIndex(where: { $0.id == workflow.id }) {
            workflows.remove(at: index)
            updateSavedWorkflows()
        }
    }
    
    func createNewWorkflowUrl(workflow: Workflow) {
        let newWorkflowItem = WorkflowItem()
        focusedField = .id(id: newWorkflowItem.id)
        workflow.addWorkflowItem(item: newWorkflowItem)
        updateSavedWorkflows()
    }
    
    func createNewWorkflowApp(workflow: Workflow) {
        // Open Finder to allow user to pick apps they want to add to the worflow
        let dialog = NSOpenPanel()

        dialog.title = "Choose multiple files | Workflows"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = true
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            let results = dialog.urls
            
            for result in results {
                let newWorkflowItem = WorkflowItem(value: result.absoluteString)
                workflow.addWorkflowItem(item: newWorkflowItem)
                updateSavedWorkflows()
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func updateSavedWorkflows() {
        guard let encodedWorkflows = try? JSONEncoder().encode(workflows) else { return }
        UserDefaults.standard.set(encodedWorkflows, forKey: "savedWorkflows")
    }
}
