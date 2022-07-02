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
    
    init(sheetInsetConduit: SheetInsetConduit) {
        self.sheetInsetConduit = sheetInsetConduit
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.components) { component in
                    ComponentView(
                        model: component,
                        coordinateSpaceName: coordinateSpaceName,
                        parentHeaders: EmptyView.init
                    )
                }
            }
                .padding(Self.internalPadding)
                .safeAreaInset(edge: .bottom, content: {
                    Color.clear
                        .frame(height: sheetInsetConduit.sheetObscuringHeight)
                })
        }
        
            .coordinateSpace(name: coordinateSpaceName)
    }
    
    public static let internalPadding: CGFloat = 30
}
