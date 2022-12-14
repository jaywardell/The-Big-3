//
//  Header.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import Combine

struct Header: View {
    
    let title: String
    
    @State private var showingKeyboard = false
    
    private var titleFont: Font {
        #if os(watchOS)
        .system(.title2, design: .default, weight: .light)
        #else
        .system(.largeTitle, design: .default, weight: .light)
        #endif
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Text(title)
                    .font(titleFont)
                    // set this so that the header will compress
                    // instead of running up off the
                    // screen when the keyboard appears
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.accentColor)
                    .padding(.leading)
                    .padding(.top)
                    .opacity(showingKeyboard ? 0 : 1)
#if os(iOS)
                Spacer()
#endif
            }
            .padding(.bottom)
            
        }
#if os(iOS)
        .onReceive(Publishers.showingKeyboard) {
            showingKeyboard = $0 }
#endif
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(title: "Plan the next Big 3")
            .accentColor(.mint)
            .previewLayout(.sizeThatFits)
    }
}

#if os(iOS)
fileprivate extension Publishers {
    // many thanks to "Yet another Swift Blog" for this approach
    // https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/
    static var showingKeyboard: AnyPublisher<Bool, Never> {

        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight > 0 }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }
        

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

fileprivate extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
#endif
