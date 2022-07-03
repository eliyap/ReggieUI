//
//  Sticky.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 27/6/22.
//

import SwiftUI

/// Indicates that this view should stick to the top of the scroll region.
struct Sticky: LayoutValueKey {
    typealias Value = Bool
    static var defaultValue: Bool = false
}

extension View {
    func sticky() -> some View {
        self.layoutValue(key: Sticky.self, value: true)
    }
}

/// Sticks a view to the the of the scroll region as long as its parent is on screen.
struct StickyLayout: Layout {
    
    /// Location of the view's origin (typically the top left corner) within the scroll region.
    let scrollLocation: CGPoint
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        /// The height of `ParentTitles`, not marked sticky, is added as a top inset.
        let nonStickyHeight = subviews
            .filter { $0[Sticky.self] == false }
            .map { $0.sizeThatFits(ProposedViewSize(bounds.size)).height }
            .reduce(0, +)
        
        for subview in subviews where subview[Sticky.self] {
            /// Do not allow the subview to escape its parents bounds.
            let maxOffset = bounds.height - subview.sizeThatFits(ProposedViewSize(bounds.size)).height - nonStickyHeight
            
            if
                (scrollLocation.y - nonStickyHeight) < 0,
                -(scrollLocation.y - nonStickyHeight) < bounds.height
            {
                /// - Note: since both are negative, this selects the number *smaller* in magnitude.
                let offset = max(-maxOffset, scrollLocation.y)
                
                subview.place(
                    at: CGPoint(
                        x: bounds.origin.x,
                        y: bounds.origin.y - offset + nonStickyHeight
                    ),
                    proposal: proposal
                )
            } else {
                subview.place(
                    at: CGPoint(
                        x: bounds.origin.x,
                        y: bounds.origin.y
                    ),
                    proposal: proposal
                )
            }
        }
    }
}
