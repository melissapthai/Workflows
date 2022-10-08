//
//  WorkflowsView.swift
//  Workflows
//
//  Created by Melissa Thai on 10/7/22.
//

import SwiftUI

struct WorkflowsView: View {
    @AppStorage("savedWorkflows") var savedWorkflows: Data = .init()
    @StateObject var workflowsViewModel = WorkflowsViewModel()

    var body: some View {
        VStack {
            ForEach(workflowsViewModel.workflows) { workflow in
                WorkflowView(workflow: workflow, workflowsViewModel: workflowsViewModel)
            }

            Divider()
                .padding(.vertical)

            Button("Create New Workflow", action: { workflowsViewModel.createNewWorkflow() })
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
