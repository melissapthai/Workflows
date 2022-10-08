//
//  WorkflowView.swift
//  Workflows
//
//  Created by Melissa Thai on 10/8/22.
//

import SwiftUI

struct WorkflowView: View {
//    @AppStorage("savedWorkflows") var savedWorkflows: Data = Data()
    @AppStorage("counter") var counter: Int = 0
    @ObservedObject var workflow: Workflow
    var workflowsViewModel: WorkflowsViewModel
    @FocusState var focusedField: Focusable?
    
    var body: some View {
        GroupBox {
            ForEach($workflow.items) { $item in
                TextField("https://google.com/", text: $item.value)
                    .padding(/*@START_MENU_TOKEN@*/ .all, 5.0/*@END_MENU_TOKEN@*/)
                    .focused($focusedField, equals: .id(id: $item.id))
                    .onSubmit {
                        workflowsViewModel.createNewWorkflowUrl(workflow: workflow)
                    }
            }
            
            HStack {
                Button("+ URL", action: {
                    workflowsViewModel.createNewWorkflowUrl(workflow: workflow)
                    counter += 1
                    print("couter: \(counter)")
                })
                
                Button("+ Application", action: { workflowsViewModel.createNewWorkflowApp(workflow: workflow) })
            }
            
            HStack {
                Button("Launch Workflow", action: workflow.launchWorkflow)
                
                Button("Delete Workflow", action: { workflowsViewModel.deleteWorkflow(workflow: workflow) })
            }
        }
        .onChange(of: focusedField) { workflowsViewModel.focusedField = $0 }
        .onChange(of: workflowsViewModel.focusedField) { focusedField = $0 }
    }
}
