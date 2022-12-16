//
//  Header.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import Combine

struct TextHeaderTitle: View {
    
    let title: String
    
    private var titleFont: Font {
#if os(watchOS)
        .system(.title2, design: .default, weight: .light)
#else
        .system(.largeTitle, design: .default, weight: .light)
#endif
    }
    
    var body: some View {
        Text(title)
            .font(titleFont)
        // set this so that the header will compress
        // instead of running up off the
        // screen when the keyboard appears
            .minimumScaleFactor(0.1)
            .foregroundColor(.accentColor)
    }
}


struct Header<Content: View>: View {
    
    init(alignment: HorizontalAlignment = .leading, _ content: @escaping ()->Content) {
        self.alignment = alignment
        self.content = content
    }
    
    let content: ()->Content
    let alignment: HorizontalAlignment
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                
                if [.trailing, .center].contains(alignment) {
                    Spacer()
                }
                
                content()
                    .padding(.horizontal)
                    .padding(.top)
                
                if [.leading, .center].contains(alignment) {
                    Spacer()
                }
            }
            .padding(.bottom)
            
        }
    }
}

extension Header where Content == TextHeaderTitle {
    init(title: String, alignment: HorizontalAlignment = .leading) {
        self.content = {
           TextHeaderTitle(title: title)
        }
        self.alignment = alignment
    }

}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Header(title: "Plan the next Big 3")
            
            Header(alignment: .center) {
                VStack {
                    Text("Plan the next")
                    Text("Big 3")
                }
            }
        }
        .accentColor(.mint)
        .previewLayout(.sizeThatFits)

    }
}
