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
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .anchor:
            Image("anchor.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .bold))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .zeroOrMore:
            Image("asterisk.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .oneOrMore:
            Image(systemName: "plus.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .optionally:
            Image(systemName: "questionmark.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .repeat:
            Image("curlybraces.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
            
        case .dateTime:
            Image("calendar.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
            
        case .currency:
            Locale.autoupdatingCurrent.currencySFSymbol
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
            
        case .decimal, .wholeNumber:
            Image("number.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .decimalPercentage, .wholeNumberPercentage:
            Image("percent.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        
        case .url:
            Image("link.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)

        case .lookahead:
            Image("lookahead.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
            
        case .negativeLookahead:
            Image("lookahead.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
                .onAppear {
                    #warning("temporary symbol, should be replaced")
                }
            
        case .choiceOf:
            Image("choiceof.app.fill")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(section.color)
                .imageScale(.large)
        }
    }
}
