//
//  CardSymbols.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 1/7/22.
//

import SwiftUI
import RegexModel

extension ComponentModel.Proxy {
    @ViewBuilder
    var symbol: some View {
        switch self {
        case .string:
            Image("abc.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.text)
                .imageScale(.large)
        
        case .anchor:
            Image("anchor.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .bold))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.text)
                .imageScale(.large)
        
        case .zeroOrMore:
            Image("asterisk.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.quantifier)
                .imageScale(.large)
        
        case .oneOrMore:
            Image(systemName: "plus.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.quantifier)
                .imageScale(.large)
        
        case .optionally:
            Image(systemName: "questionmark.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.quantifier)
                .imageScale(.large)
            
        
        case .repeat:
            Image("curlybraces.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.quantifier)
                .imageScale(.large)
        
        case .lookahead:
            Image("lookahead.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.other)
                .imageScale(.large)
            
        case .choiceOf:
            Image("choiceof.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.other)
                .imageScale(.large)
        }
    }
}
