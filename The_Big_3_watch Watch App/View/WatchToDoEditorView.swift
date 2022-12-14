//
//  WatchToDoEditorView.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/14/22.
//

import SwiftUI

struct WatchToDoEditorView: View {
    
    let todo: String
    
    let finish: ()->()
    let postpone: ()->()
    
    var body: some View {
        VStack {
            Header(title: todo)
            
            Spacer()
            
            Button("not today", action: postpone)
            
            Button("Done", action: finish)
                .buttonStyle(.borderedProminent)
        }
    }
}

struct WatchToDoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        WatchToDoEditorView(todo: "Call the doctor and ask for some advice on this foot fungus", finish: {}, postpone: {})
            .accentColor(.green)
    }
}
