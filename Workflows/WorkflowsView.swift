//
//  WorkflowsView.swift
//  Workflows
//
//  Created by Melissa Thai on 10/7/22.
//

import SwiftUI

class Workflow: Identifiable, ObservableObject {
    let id: String = UUID().uuidString
    @Published var items: [WorkflowItem]
    
    init() {
        self.items = []
    }
    
    init(items: [WorkflowItem]) {
        self.items = items
    }
    
    func launchWorkflow() {
        for item in items {
            if let url = URL(string: item.value) {
                NSWorkspace.shared.open(url)
            } else {
                print("Unable to open \(item.value)")
            }
        }
    }
}

class WorkflowItem: Identifiable, ObservableObject {
    let id: String = UUID().uuidString
    @Published var value: String
    
    init() {
        self.value = ""
    }
    
    init(value: String) {
        self.value = value
    }
}

enum Focusable: Hashable {
    case id(id: String)
}

class WorkflowsViewModel: ObservableObject {
    @Published var workflows: [Workflow]
    @Published var focusedField: Focusable?
    
    init() {
        self.workflows = []
    }
    
    init(workflows: [Workflow]) {
        self.workflows = workflows
    }
    
    func createNewWorkflow() {
        print("creating new workflow!")
        let newWorkflow = Workflow()
        let newWorkflowItem = WorkflowItem()
        
        newWorkflow.items.append(newWorkflowItem)
        
        focusedField = .id(id: newWorkflowItem.id)
        workflows.append(newWorkflow)
    }
    
    func createNewWorkflowUrl(workflow: Workflow) {
        print("creating new workflow url!")
        let newWorkflowItem = WorkflowItem()
        workflow.items.append(newWorkflowItem)
        focusedField = .id(id: newWorkflowItem.id)
    }
    
    func createNewWorkflowApp(workflow: Workflow) {
        print("creating new workflow app!")
        
        let dialog = NSOpenPanel()

        dialog.title = "Choose multiple files | Workflows"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = false
        dialog.allowsMultipleSelection = true
        
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            // Results contains an array with all the selected paths
            let results = dialog.urls
            
            // Do whatever you need with every selected file
            // in this case, print on the terminal every path
            for result in results {
                // /Users/ourcodeworld/Desktop/fileA.txt
                workflow.items.append(WorkflowItem(value: result.absoluteString))
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
        let newWorkflowItem = WorkflowItem()
        workflow.items.append(newWorkflowItem)
    }
}

struct WorkflowView: View {
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
                Button("+ URL", action: { workflowsViewModel.createNewWorkflowUrl(workflow: workflow) })
                
                Button("+ Application", action: { workflowsViewModel.createNewWorkflowApp(workflow: workflow) })
            }

            Button("Launch Workflow", action: workflow.launchWorkflow)
        }
        .onChange(of: focusedField) { workflowsViewModel.focusedField = $0 }
        .onChange(of: workflowsViewModel.focusedField) { focusedField = $0 }
    }
}

struct WorkflowsView: View {
    @StateObject var workflowsViewModel = WorkflowsViewModel(workflows: [Workflow(items: [WorkflowItem()])])
    
    var body: some View {
        VStack {
            ForEach(workflowsViewModel.workflows) { workflow in
                WorkflowView(workflow: workflow, workflowsViewModel: workflowsViewModel)
            }
            
            Divider()
                .padding(.vertical)
            
            Button("Create New Workflow", action: workflowsViewModel.createNewWorkflow)
                .padding(.vertical, 1.0/*@END_MENU_TOKEN@*/)
        }
        .padding(/*@START_MENU_TOKEN@*/ .all/*@END_MENU_TOKEN@*/)
    }
}

struct Previews_WorkflowsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkflowsView()
    }
}
