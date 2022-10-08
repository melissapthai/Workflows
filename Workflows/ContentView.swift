//
//  ContentView.swift
//  Workflows
//
//  Created by Melissa Thai on 10/7/22.
// TODO: refactor to conform to MVVM: https://peterfriese.dev/posts/swiftui-list-focus/
//

import SwiftUI

struct ContentView: View {
    struct Workflow: Identifiable {
      let id: String = UUID().uuidString
      var items: [WorkflowItem] = []
    }
    
    struct WorkflowItem: Identifiable {
      let id: String = UUID().uuidString
      var value: String = ""
    }
    
    enum Focusable: Hashable {
      case none
      case index(id: String)
    }
    
    @State private var workflows: [Workflow] = [
        Workflow(items: [WorkflowItem(value: "https://google.com")])
    ]
    
    @FocusState private var focusedField: Focusable?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Workflows")
                .font(.title)
                .foregroundColor(Color.blue)
            
            ForEach(workflows) { workflow in
                GroupBox {
//                    ForEach(workflow.items) { item in
//                        TextField("https://google.com/", text: item.$value)
//                            .focused($focusedField, equals: .index(id: item.id))
//                            .onSubmit {
//                                createNewWorkflowItem(workflow: workflow)
//                            }
//                    }

                    Button("+", action: { createNewWorkflowItem(workflow: workflow) })

                    Button("Launch Workflow", action: { launchWorkflow(urls: workflow.items) })
                }
            }
            
            Button("Create New Workflow", action: createNewWorkflow)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .frame(width: 300, height: 300)
    }
    
    func createNewWorkflow() {
        workflows.append(Workflow())
    }
    
    func createNewWorkflowItem(workflow: Workflow) {
        var newWorkflowItem = WorkflowItem()
//        workflow.items.append(newWorkflowItem)
        focusedField = .index(id: newWorkflowItem.id)
    }
    
    func launchWorkflow(urls: [WorkflowItem]) {
        for url in urls {
            guard let url = URL(string: url.value) else {
              return
            }
            
            NSWorkspace.shared.open(url)
            print(url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
