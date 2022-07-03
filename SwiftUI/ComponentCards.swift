//
//  ComponentCards.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 1/7/22.
//

import SwiftUI
import RegexModel

struct StringCard<ParentTitles: View>: TitledCardView {
    
    let params: StringParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("String", symbol)
    }
    
    var contents: some View {
        Group {
            Text(params.string)
        }
    }
}

struct ZeroOrMoreCard<ParentTitles: View>: TitledCardView {
    
    let params: ZeroOrMoreParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Zero Or More", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
            }
        }
    }
}

struct OneOrMoreCard<ParentTitles: View>: TitledCardView {
    
    let params: OneOrMoreParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("One Or More", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
            }
        }
    }
}

struct OptionallyCard<ParentTitles: View>: TitledCardView {
    
    let params: OptionallyParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Optionally", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
            }
        }
    }
}

struct RepeatCard<ParentTitles: View>: TitledCardView {
    
    let params: RepeatParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Repeat", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
            }
        }
    }
}

struct LookaheadCard<ParentTitles: View>: TitledCardView {
    
    let params: LookaheadParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Lookahead", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
            }
        }
    }
}

struct ChoiceOfCard<ParentTitles: View>: TitledCardView {
/// Pick a card, any card...
    
    let params: ChoiceOfParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Choice Of", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
            }
        }
    }
}

struct AnchorCard<ParentTitles: View>: TitledCardView {
    
    let params: AnchorParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Anchor", symbol)
    }
    
    #warning("temporary")
    var contents: some View {
        Group {
            Text("params.boundary")
        }
    }
}
