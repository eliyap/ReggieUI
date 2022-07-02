//
//  ContentView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import SwiftUI
import Combine

struct RegexView: View {
    
    @StateObject private var model: _RegexModel = .init(components: _RegexModel.example)
    
    /// In case of multiple instances, ensure this is instance specific.
    private let coordinateSpaceName = UUID().uuidString
    
    @ObservedObject private var sheetInsetConduit: SheetInsetConduit
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    init(sheetInsetConduit: SheetInsetConduit) {
        self.sheetInsetConduit = sheetInsetConduit
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .trailing, spacing: interCardSpacing) {
                DropRegion()
                ForEach(model.components) { component in
                    ComponentView(
                        model: component,
                        coordinateSpaceName: coordinateSpaceName,
                        parentHeaders: EmptyView.init
                    )
                    DropRegion()
                }
            }
                .padding(internalPadding)
        }
            /// - Warning:
            /// When reducing sheet detent, scroll view does **NOT** move down if at bottom.
            /// Though we could fix this by moving the `safeAreaInset` inside the `ScrollView`,
            /// - it breaks hover-at-edge scrolling
            /// - it does not update the scroll bar insets
            .safeAreaInset(edge: .bottom, content: {
                Color.clear
                    .frame(height: sheetInsetConduit.sheetObscuringHeight)
            })
            .coordinateSpace(name: coordinateSpaceName)
            .background {
                BackgroundColor()
                    .ignoresSafeArea()
            }
    }
    
    private var internalPadding: CGFloat {
        horizontalSizeClass == .compact
            ? 24
            : 32
    }
            
    fileprivate struct BackgroundColor: View {
        
        @Environment(\.colorScheme) private var colorScheme
        
        var body: some View {
            switch colorScheme {
            case .dark:
                Color(uiColor: .systemBackground)
            case .light:
                Color(uiColor: .secondarySystemBackground)
            @unknown default:
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }
}
