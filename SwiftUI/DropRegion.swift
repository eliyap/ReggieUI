//
//  DropRegion.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 3/7/22.
//

import SwiftUI
import RegexModel

struct DropRegion: View {
    
    @EnvironmentObject private var dropConduit: DropConduit
    @State private var hovered = false
    
    @Binding public var cardHovered: RelativeLocation?
    public let path: ModelPath
    public var relativeLocation: RelativeLocation
    
    var body: some View {
        Color.clear
            .frame(height: height)
            .background {
                if hovered {
                    Placeholder()
                }
            }
            .overlay {
                DropWatcher
            }
    }
    
    // MARK: - Hover / Drop Logic
    private var DropWatcher: some View {
        GeometryReader { proxy in
            Color.clear
                .onReceive(dropConduit.$dropLocation) { location in
                    respondTo(location: location, proxy: proxy)
                }
        }
    }
    
    let animation: Animation = .easeInOut(duration: 0.15)
    
    private func respondTo(location: CGPoint?, proxy: GeometryProxy) -> Void {
        /// Check whether location is within region.
        guard let location else {
            withAnimation(animation) {
                /// Clear UI.
                hovered = false
                cardHovered = nil
            }
            return
        }

        let frame = proxy.frame(in: .named(DropConduit.scrollCoordinateSpace))
        let inside = frame.contains(location)
        withAnimation(animation) {
            /// Trigger variable changes simultaneously, as `.onChanged` has a slight delay.
            if hovered != inside {
                cardHovered = inside ? relativeLocation : nil
            }
            hovered = inside
        }
    }
    
    // MARK: - Height Calculation
    public static let baseHeight: CGFloat = 20
    
    /// - Note: If equal to the `baseHeight`, it's possible to "skip over" a drop region.
    ///         Make it significantly less!
    let heightAdjustment: CGFloat = 10
    
    var height: CGFloat {
        if hovered {
            return Self.baseHeight + heightAdjustment
        }
        
        switch cardHovered {
        case .middle:
            switch relativeLocation {
            case .bottom, .top:
                return Self.baseHeight - heightAdjustment / 2
            default:
                break
            }
        
        case .top:
            if case .bottom = relativeLocation {
                return Self.baseHeight - heightAdjustment
            }
            
        case .bottom:
            if case .top = relativeLocation {
                return Self.baseHeight - heightAdjustment
            }
        
        case .none:
            break
        }
        
        return Self.baseHeight
    }
}

extension DropRegion {
    /// Indicates whether the region is at the top, bottom, or middle of the card.
    internal enum RelativeLocation {
        case top, middle, bottom
    }
}

fileprivate struct Placeholder: View {
    
    let backgroundColor = Color.green.opacity(0.1)
    let foregroundColor = Color.green.opacity(0.25)
    
    var body: some View {
        ZStack {
            Image(systemName: "plus")
                .font(Font.system(.body, design: .rounded, weight: .black))
                .foregroundColor(foregroundColor)
            RoundedRectangle(cornerRadius: titleCornerRadius)
                .foregroundColor(backgroundColor)
            RoundedRectangle(cornerRadius: titleCornerRadius)
                .strokeBorder(foregroundColor, style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 0,
                    dash: [10, 10]
                ))
        }
            .padding(.vertical, 4)
            .transition(.opacity)
    }
}
