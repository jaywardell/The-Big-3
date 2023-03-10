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
        
    @State private var presentedToDo = [Int]()

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack(path: $presentedToDo) {
                Header {  BrandedHeader(layout: .watchTitle) }
                
                CountedRows(rows: viewModel.count) { index in
                    row(at: index)
                }
                .navigationDestination(for: Int.self) { index in
                    detailView(for: index)
                }
            }
        }
    }
    
    private func row(at index: Int) -> some View {
        let todo = viewModel.todoAt(index)
        
        return GoalView(todo: todo,
                 backgroundColor: .accentColor,
                 template: .watch(showDetail: {
            if todo.state == .ready {
                presentedToDo = [index]
            }
        }))
    }
    
    private func detailView(for index: Int) -> some View {
        WatchToDoEditorView(
            todo: viewModel.todoAt(index).title,
            finish: { finishButtonTapped(forToDoAt: index) },
            postpone: {  postponeButtonWasTapped(forToDoAt: index) })
    }
    
    private func finishButtonTapped(forToDoAt index: Int) {
        viewModel.finish(index)
        presentedToDo = []
    }
    
    private func postponeButtonWasTapped(forToDoAt index: Int) {
        viewModel.postpone(index)
        presentedToDo = []
    }
}

#if DEBUG
struct WatchPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WatchPlanView(viewModel: Planner(plan: .example).watchPlanViewModel())
            .accentColor(.mint)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
#endif
