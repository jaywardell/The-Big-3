//
//  WidgetSummationView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/15/22.
//

import SwiftUI
import WidgetKit

struct WidgetSummationView: View {
    
    struct ViewModel {
        let total: Int
        let completed: Int
        
        let todoAt: (Int)->GoalView.ToDo

    }
    let viewModel: ViewModel
    
    @Environment(\.widgetFamily) var widgetFamily

    private var titleText: String {
        switch viewModel.completed {
        case viewModel.total:
            return "Congratulations!"
        default:
            return ""
        }
    }
    
    private var completionString: String {
        var out = "You finished "
        
        switch viewModel.completed {
        case viewModel.total:
            out += "all"
        case 0:
            out += "none"
        default:
            out += String(viewModel.completed)
        }
        
        out += " of the Big 3."
        
        return out
    }
    
    private var summaryLayout: GraphicSummary.Layout {
        switch widgetFamily {
        case .systemSmall: return .circular
        default: return .normal
        }
    }
    
    var body: some View {
        if widgetFamily == .accessoryRectangular {
            VStack {
                BrandedHeader(layout: .inlinemain)
                    .padding(.bottom, 2)
                GraphicSummary(viewModel: .init(total: viewModel.total, todoAt: viewModel.todoAt))
                    .font(.headline)
                    .bold()
            }
        }
        else if widgetFamily == .accessoryInline {
            Text("\(viewModel.completed) out of \(viewModel.total)")
        }
        else if widgetFamily == .accessoryCircular {
            GraphicSummary(viewModel: .init(total: viewModel.total, todoAt: viewModel.todoAt), layout: .circular)
        }
        else {
            VStack(alignment: .center) {
                
                Spacer()
                
                if viewModel.completed == viewModel.total,
                   [.systemLarge, .systemExtraLarge].contains(widgetFamily) {
                    Header(title: titleText, alignment: .center)
                        .padding(.bottom)
                    
                    Spacer()
                }
                
                GraphicSummary(viewModel: .init(total: viewModel.total, todoAt: viewModel.todoAt), layout: summaryLayout)
                    .font(.largeTitle)
                
                if [.systemLarge, .systemMedium, .systemExtraLarge].contains(widgetFamily) {
                    Text(completionString)
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.top)
                    Spacer()
                }
                
            }
        }
    }
}

struct WidgetSummationView_Previews: PreviewProvider {
    static var previews: some View {
        
        let families: [WidgetFamily] = [
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge
        ]
        
        ForEach(families, id: \.self) { family in
            WidgetSummationView(viewModel: .init(total: 3, completed: 3, todoAt: { _ in .init(title: "do something", state: .finished) }))
                .previewContext(WidgetPreviewContext(family: family))
                .previewDisplayName("\(family)")
        }
    }
}
