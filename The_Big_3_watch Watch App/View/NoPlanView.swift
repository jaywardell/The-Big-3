//
//  NoPlanView.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import SwiftUI

struct NoPlanView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            HStack {
                VStack {
                    Text("Plan the Next")
                        .font(.system(.caption2, design: .default, weight: .ultraLight))
                    Text("Big")
                        .font(.system(.largeTitle, design: .default, weight: .ultraLight)) +
                    Text("3")
                        .font(.system(.largeTitle, design: .monospaced, weight: .black))
                        .bold()
                        .foregroundColor(.accentColor)
                }
            }
            
            Spacer()
            
            Text("You have not yet planned your Big 3.")
                .font(.footnote)
            Spacer()
            Text("Sadly, you can only do this on your phone for now.")
                .font(.footnote)
        }
    }
}

struct NoPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NoPlanView()
    }
}
