//
//  CountedRows.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/17/22.
//

import SwiftUI

struct CountedRows<Content: View>: View {
    
    let rows: Int
    let rowAt: (Int)->Content
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...rows-1, id: \.self) { index in
                rowAt(index)
                
                if index < rows-1 {
                    Divider()
                }
            }
        }
    }
}

struct CountedRows_Previews: PreviewProvider {
    static var previews: some View {
        CountedRows(rows: 4) { Text(String($0)) }
    }
}
