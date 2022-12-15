//
//  Animation+Constants.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/16/22.
//

import SwiftUI

extension Animation {
    
    static let Big3Spring = Animation.spring(response: 21/34.0, dampingFraction: 21/34.0, blendDuration: 21/34.0)
    static let Big3HeaderSpring = Animation.easeInOut(duration: 13/34)

}

