//
//  ComponentView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 29/6/22.
//

import SwiftUI
import RegexModel

/// Multiplexer view that resolves the enum to a specific case.
struct ComponentView<ParentHeader: View>: View {
    
    public let model: ComponentModel
    public let path: ModelPath
    public let mgeNamespace: Namespace.ID
    public let parentHeaders: () -> ParentHeader
    
    var body: some View {
        Mux
            .matchedGeometryEffect(id: model.id, in: mgeNamespace)
    }
    
    @ViewBuilder
    private var Mux: some View {
        switch model {
        case .string(let params):
            StringCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
        
        case .zeroOrMore(let params):
            ZeroOrMoreCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
        
        case .oneOrMore(let params):
            OneOrMoreCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .optionally(let params):
            OptionallyCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .repeat(let params):
            RepeatCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .lookahead(let params):
            LookaheadCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
            
        case .choiceOf(let params):
            ChoiceOfCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
            
        case .anchor(let params):
            AnchorCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
        }
    }
}
