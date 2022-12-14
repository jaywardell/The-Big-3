//
//  BrandedHeader.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import SwiftUI

struct BrandedHeader: View {
    
    enum Layout { case square, minisquare, planningTitle, mainTitle, watchTitle }
    let layout: Layout
    
    let planString = "Plan the Next"
    let theString = "the"
    let bigString = "Big"
    let threeString = "3"

    var minisquare: some View {
        VStack {
            Text(planString)
                .font(.system(.caption, design: .default, weight: .ultraLight))
            Text(bigString)
                .font(.system(.title3, design: .default, weight: .ultraLight)) +
            Text(threeString)
                .font(.system(.largeTitle, design: .monospaced, weight: .black))
                .bold()
                .foregroundColor(.accentColor)
        }
    }

    var square: some View {
        VStack {
            Text(planString)
                .font(.system(.caption2, design: .default, weight: .ultraLight))
            Text(bigString)
                .font(.system(.largeTitle, design: .default, weight: .ultraLight)) +
            Text(threeString)
                .font(.system(.largeTitle, design: .monospaced, weight: .black))
                .bold()
                .foregroundColor(.accentColor)
        }
    }
    
    var planningTitle: some View {
        VStack(alignment: .leading) {
            Text(planString)
                .font(.system(.title3, design: .default, weight: .ultraLight))
            Text(bigString)
                .font(.system(.largeTitle, design: .default, weight: .ultraLight)) +
            Text(threeString)
                .font(.system(.largeTitle, design: .monospaced, weight: .black))
                .bold()
                .foregroundColor(.accentColor)
        }
    }
    
    var mainTitle: some View {
        VStack(alignment: .leading) {
            Text(theString)
                .font(.system(.title, design: .default, weight: .ultraLight)) +
            Text(" ") +
            Text(bigString)
                .font(.system(.largeTitle, design: .default, weight: .ultraLight)) +
            Text(threeString)
                .font(.system(.largeTitle, design: .monospaced, weight: .black))
                .bold()
                .foregroundColor(.accentColor)
        }
    }
    
    var watchTitle: some View {
        VStack(alignment: .leading) {
            Text(theString)
                .font(.system(.title3, design: .default, weight: .ultraLight)) +
            Text(" ") +
            Text(bigString)
                .font(.system(.title2, design: .default, weight: .ultraLight)) +
            Text(threeString)
                .font(.system(.title2, design: .monospaced, weight: .black))
                .bold()
                .foregroundColor(.accentColor)
        }
    }



    var body: some View {
        switch layout {
        case .square: square
        case .planningTitle: planningTitle
        case .mainTitle: mainTitle
        case .watchTitle: watchTitle
        case .minisquare: minisquare
        }
    }
}

struct BrandedHeader_Previews: PreviewProvider {
    static var previews: some View {
        BrandedHeader(layout: .square)
            .accentColor(.pink)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("square")

        BrandedHeader(layout: .minisquare)
            .accentColor(.pink)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("mini square")

        BrandedHeader(layout: .planningTitle)
            .accentColor(.pink)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("planning title")

        BrandedHeader(layout: .mainTitle)
            .accentColor(.pink)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("main title")

        BrandedHeader(layout: .watchTitle)
            .accentColor(.pink)
            .padding()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("watch title")
    }
}
