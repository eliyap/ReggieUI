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
    public let coordinateSpaceName: String
    public let parentHeaders: () -> ParentHeader
    
    var body: some View {
        switch model {
        case .string(let params):
            StringCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)
        
        case .zeroOrMore(let params):
            ZeroOrMoreCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)
        
        case .oneOrMore(let params):
            OneOrMoreCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)

        case .optionally(let params):
            OptionallyCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)

        case .repeat(let params):
            RepeatCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)

        case .lookahead(let params):
            LookaheadCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)
            
        case .choiceOf(let params):
            ChoiceOfCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)
            
        case .anchor(let params):
            AnchorCard(params: params, coordinateSpaceName: coordinateSpaceName, parentTitles: parentHeaders)
        }
    }
}

struct DropRegion: View {
    
    @ScaledMetric private var radius: CGFloat = 10
    @ScaledMetric private var height: CGFloat = 30
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .frame(height: height)
            .foregroundColor(Color.purple.opacity(0.1))
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(
                        Color.purple.opacity(0.25),
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round,
                            miterLimit: 0,
                            dash: [10, 10]
                        )
                    )
                    .frame(height: height)
            }
            .overlay {
                Image(systemName: "plus")
                    .font(Font.system(.body, design: .rounded, weight: .black))
                    .foregroundColor(Color.purple.opacity(0.25))
                    .frame(height: height)
            }
    }
}
