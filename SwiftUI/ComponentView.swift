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
        case .character(let params):
            CharacterCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
            
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

        case .dateTime(let params):
            DateTimeCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .currency(let params):
            CurrencyCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .decimal(let params):
            DecimalCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .wholeNumber(let params):
            WholeNumberCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
        
        case .decimalPercentage(let params):
            DecimalPercentageCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .wholeNumberPercentage(let params):
            WholeNumberPercentageCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)

        case .url(let params):
            URLCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
        
        case .lookahead(let params):
            LookaheadCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
            
        case .negativeLookahead(let params):
            NegativeLookaheadCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
            
        case .choiceOf(let params):
            ChoiceOfCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
            
        case .anchor(let params):
            AnchorCard(params: params, path: path, mgeNamespace: mgeNamespace, parentTitles: parentHeaders)
        }
    }
}
