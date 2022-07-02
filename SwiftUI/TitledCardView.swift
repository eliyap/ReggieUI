//
//  TitledCardView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 29/6/22.
//

import SwiftUI
import RegexModel

protocol TitledCardView: View {
    
    associatedtype ParentTitles:  View
    associatedtype Title:         View
    associatedtype Contents:      View
    associatedtype Symbol:        View
    
    /// Allows title to find location within the scroll region.
    var coordinateSpaceName: String      { get }
    
    var insets: EdgeInsets               { get }
    var parentTitles: () -> ParentTitles { get }
    var title: Title                     { get }
    var contents: Contents               { get }
    var symbol: Symbol                   { get }
}

fileprivate let titleCornerRadius: CGFloat = 16
fileprivate let intraCardSpacing: CGFloat = 10
let interCardSpacing: CGFloat = 30
internal let cardInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8)

extension TitledCardView {
    
    var body: some View {
        VStack(spacing: intraCardSpacing) {
            /// Placeholder to push contents down.
            title
                .opacity(0)
            contents
                .padding(insets)
        }
            .background {
                CardBackground()
                    .clipShape(RoundedRectangle(cornerRadius: titleCornerRadius))
                    .modifier(TitleShadow())
            }
            .overlay {
                /// - Note: The sticky header and placeholder header **must** have equal dimensions.
                ///         Give them the same width and layout "treatments" i.e. padding, etc.
                GeometryReader { geo in
                    StickyLayout(scrollLocation: geo.frame(in: .named(coordinateSpaceName)).origin) {
                        Group {
                            parentTitles()
                                .opacity(0)
                            title
                                .sticky()
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: titleCornerRadius))
            }
    }
}

struct TitleShadow: ViewModifier {
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: colorScheme == .light
                    ? Color.black.opacity(0.16)
                    : Color.black.opacity(0.24),
                radius: colorScheme == .light
                    ? 12
                    : 6
            )
    }
}

internal struct CardBackground: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Self.color(colorScheme)
    }
    
    static func color(_ colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return Color(uiColor: .secondarySystemBackground)
        case .light:
            return Color(uiColor: .systemBackground)
        @unknown default:
            return Color(uiColor: .secondarySystemBackground)
        }
    }
}

fileprivate let titlePadding: CGFloat = 12

func DefaultTitle(_ string: String, _ symbol: some View) -> some View {
    HStack(spacing: titlePadding / 2) {
        symbol
        Text(string)
        Spacer()
    }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(titlePadding)
        .background(CardBackground())
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 2)
                .modifier(DividerForeground())
        }
}

fileprivate struct DividerForeground: ViewModifier {
    
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light
                ? Color(uiColor: .secondarySystemBackground)
                : Color(uiColor: .tertiarySystemBackground)
            )
    }
}
