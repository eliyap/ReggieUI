//
//  ContentView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        StickyScrollView()
    }
}

struct RegexView: View {
    
    @StateObject private var model: _RegexModel = .init(components: _RegexModel.example)
    
    /// In case of multiple instances, ensure this is instance specific.
    private let coordinateSpaceName = UUID().uuidString
    
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
        }
            .coordinateSpace(name: coordinateSpaceName)
    }
    
    public static let internalPadding: CGFloat = 30
}

struct StickyScrollView: View {
    
    let coordinateSpaceName = UUID().uuidString
    
    var body: some View {
        RegexView()
    }
}
