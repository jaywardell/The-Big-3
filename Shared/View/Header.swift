//
//  Header.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI

struct Header: View {
    
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text(title)
                    .font(.system(.largeTitle, design: .default, weight: .light))
                    .foregroundColor(.accentColor)
                    .padding(.leading)
                    .padding(.top)
                Spacer()
            }
            .padding(.bottom)
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: "Plan the next Big 3")
            .accentColor(.mint)
            .previewLayout(.sizeThatFits)
    }
}
