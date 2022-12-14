//
//  WatchPlanView.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import SwiftUI

struct WatchPlanView: View {
    
    final class ViewModel: ObservableObject {

        let count: Int
        let todoAt: (Int)->GoalView.ToDo

        let finish: (Int)->()
        let postpone: (Int)->()

        init(count: Int,
             todoAt: @escaping (Int) -> GoalView.ToDo,
             finish: @escaping (Int) -> Void,
             postpone: @escaping (Int) -> Void) {
            self.count = count
            self.todoAt = todoAt
            self.finish = finish
            self.postpone = postpone
        }
    }
    @ObservedObject var viewModel: ViewModel
        
    @State private var presentedToDo = [GoalView.ToDo]()

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack(path: $presentedToDo) {
                Header(title: "The Big 3")
                CountedRows(rows: viewModel.count) { index in
                    row(at: index)
                }
                .navigationDestination(for: GoalView.ToDo.self) { i in
                    Text("Detail \(i.title)")
                }
            }
        }
    }
    
    private func row(at index: Int) -> some View {
        let todo = viewModel.todoAt(index)
        return GoalView(todo: todo,
                 backgroundColor: .accentColor,
                 template: .watch(showDetail: {
            presentedToDo = [todo]
        }))
    }
}

struct WatchPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WatchPlanView(viewModel: Planner(plan: .example).watchPlanViewModel())
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
