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
            
            
            BrandedHeader(layout: .square)
            
            Spacer()
            
            Text("You have not yet planned your Big 3.")
                .font(.footnote)
            Spacer()
            Text("To do this, open The Big 3 on your phone.")
                .font(.footnote)
        }
    }
}

struct NoPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NoPlanView()
            .accentColor(.indigo)
    }
}
