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
                .onReceive(dropConduit.$dropLocation) { location, event in
                    respondTo(location: location, event: event, proxy: proxy)
                }
        }
    }
    
    let animation: Animation = .easeInOut(duration: 0.15)
    
    private func respondTo(location: CGPoint?, event: DropConduit.Event?, proxy: GeometryProxy) -> Void {
        /// Check whether location is within region.
        guard let location else {
            withAnimation(animation) {
                /// Trigger variable changes simultaneously, as `.onChanged` has a slight delay.
                if hovered == true {
                    cardHovered = nil
                }
                hovered = false
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
        
        /// Check for drop commitment
        if inside, case .drop(let id) = event {
            dropConduit.dropPath = (id, path)
        }
    }
    
    // MARK: - Height Calculation
    let baseHeight: CGFloat = 20
    let heightAdjustment: CGFloat = 20
    
    var height: CGFloat {
        if hovered {
            return baseHeight + heightAdjustment
        }
        
        switch cardHovered {
        case .middle:
            switch relativeLocation {
            case .bottom, .top:
                return baseHeight - heightAdjustment / 2
            default:
                break
            }
        
        case .top:
            if case .bottom = relativeLocation {
                return baseHeight - heightAdjustment
            }
            
        case .bottom:
            if case .top = relativeLocation {
                return baseHeight - heightAdjustment
            }
        
        case .none:
            break
        }
        
        return baseHeight
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
