//
//  Color+Constants.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import SwiftUI

// give Color some of the same constants that UIColor uses,
// to kae it easy to provide semantic no matter what target
extension Color {
    static var label: Color {
        #if os(watchOS)
        .primary
        #else
        Color(uiColor: .label)
        #endif
    }
    
    static var secondaryLabel: Color {
#if os(watchOS)
        Color(cgColor: .init(gray: 0.8, alpha: 1))
#else
        Color(uiColor: .secondaryLabel)
#endif
    }
    
    static var systemBackground: Color {
#if os(watchOS)
        .black
#else
        Color(uiColor: .systemBackground)
#endif

    }
}
