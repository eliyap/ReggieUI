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
    let coordinateSpaceName: String
    let parentHeaders: () -> ParentHeader
    
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

/// Lays out children at ideal size, while itself taking up a 1x1 area.
struct ZeroSizeLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        /// `0, 0` results in not being drawn, so trick the layout engine.
        return CGSize(width: 1, height: 1)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for subview in subviews {
            /// Get ideal size.
            let size = subview.sizeThatFits(.infinity)
            
            var location = bounds.origin
            location.x -= size.width / 2
            location.y -= size.height / 2
            
            subview.place(at: location, proposal: ProposedViewSize.infinity)
        }
    }
}

struct DropRegion: View {
    
    @ScaledMetric private var radius: CGFloat = 10
    @ScaledMetric private var height: CGFloat = 30
    
    var body: some View {
        ZeroSizeLayout {
            Tab
                .offset(x: cardInsets.trailing)
        }
    }
    
    private var Tab: some View {
        Image(systemName: "plus.diamond.fill")
            .imageScale(.large)
            .symbolRenderingMode(.hierarchical)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .modifier(TabBackground())
                    .rotationEffect(Angle(degrees: 45))
            }
    }
}

fileprivate struct TabBackground: ViewModifier {
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(CardBackground.color(colorScheme))
    }
}
