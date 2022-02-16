//
//  TitledWithToolbar.swift
//  SwiftUI_Layouts_Examples
//
//  Created by Joseph Wardell on 2/15/22.
//

import SwiftUI

struct TitledWithToolbar<Content: View, ToolbarContent: View>: View {
    
    let title: String
    let content: ()->Content
    let toolbarContent: ()->ToolbarContent

    init(_ title: String, _ content: @escaping ()->Content,
        toolbar: @escaping ()->ToolbarContent) {
        self.title = title
        self.toolbarContent = toolbar
        self.content = content
    }
    
#if os(macOS)
#else
    @Environment(\.verticalSizeClass) var verticalSizeClass
#endif

    var body: some View {
        
#if os(macOS)
        content()
            .navigationTitle(title)
            .toolbar {
                Button(action: nextButtonAction) {
                    Text(nextButtonTitle)
                }
                
            }
#else
        
        if UIDevice.current.userInterfaceIdiom == .phone && verticalSizeClass == .regular {
            NavigationView {
                content()
                    .navigationTitle(title)
                    .toolbar {
                        toolbarContent()
                    }
            }
        }
        else {
            VStack {
                HStack {
                    Text(title)
                        .font(.largeTitle.bold())
                        .padding()
                    Spacer()
                    toolbarContent()
                    .padding()
                }
                content()
            }
        }
#endif
    }
}


#if DEBUG

fileprivate struct ExampleContentView: View {
    
    var body: some View {
        Circle().fill(Color.red)
    }
}

struct TitledWithToolbar_Previews: PreviewProvider {
    static var previews: some View {
        TitledWithToolbar("Hello") {
            ExampleContentView()
        } toolbar: {
            Button("Next¬") {}
        }
    }
}

#endif
