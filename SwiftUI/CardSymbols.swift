//
//  CardSymbols.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 1/7/22.
//

import SwiftUI
import RegexModel

extension StringCard {
    var symbol: some View {
        Image("abc.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.text)
            .imageScale(.large)
    }
}

extension ZeroOrMoreCard {
    var symbol: some View {
        Image("asterisk.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.quantifier)
            .imageScale(.large)
    }
}

extension OneOrMoreCard {
    var symbol: some View {
        Image(systemName: "plus.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.quantifier)
            .imageScale(.large)
    }
}

extension OptionallyCard {
    var symbol: some View {
        Image(systemName: "questionmark.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.quantifier)
            .imageScale(.large)
    }
}

extension RepeatCard {
    var symbol: some View {
        Image("curlybraces.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.quantifier)
            .imageScale(.large)
    }
}

extension LookaheadCard {
    var symbol: some View {
        Image("lookahead.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.other)
            .imageScale(.large)
    }
}

extension ChoiceOfCard {
    var symbol: some View {
        Image("choiceof.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .black))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.other)
            .imageScale(.large)
    }
}

extension AnchorCard {
    var symbol: some View {
        Image("anchor.app.fill")
            .font(Font.system(.body, design: .rounded, weight: .bold))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.text)
            .imageScale(.large)
    }
}
