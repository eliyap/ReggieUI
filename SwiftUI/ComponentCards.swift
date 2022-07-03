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
    let mgeNamespace: Namespace.ID
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
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: ZeroOrMoreParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Zero Or More", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, coordinateSpaceName: coordinateSpaceName, id: params.id, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    mgeNamespace: mgeNamespace,
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                DropRegion(
                    cardHovered: $cardHovered,
                    coordinateSpaceName: coordinateSpaceName,
                    id: params.id,
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct OneOrMoreCard<ParentTitles: View>: TitledCardView {
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: OneOrMoreParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("One Or More", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, coordinateSpaceName: coordinateSpaceName, id: params.id, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    mgeNamespace: mgeNamespace,
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                DropRegion(
                    cardHovered: $cardHovered,
                    coordinateSpaceName: coordinateSpaceName,
                    id: params.id,
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct OptionallyCard<ParentTitles: View>: TitledCardView {
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: OptionallyParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Optionally", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, coordinateSpaceName: coordinateSpaceName, id: params.id, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    mgeNamespace: mgeNamespace,
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                DropRegion(
                    cardHovered: $cardHovered,
                    coordinateSpaceName: coordinateSpaceName,
                    id: params.id,
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct RepeatCard<ParentTitles: View>: TitledCardView {
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: RepeatParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Repeat", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, coordinateSpaceName: coordinateSpaceName, id: params.id, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    mgeNamespace: mgeNamespace,
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                DropRegion(
                    cardHovered: $cardHovered,
                    coordinateSpaceName: coordinateSpaceName,
                    id: params.id,
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct LookaheadCard<ParentTitles: View>: TitledCardView {
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: LookaheadParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Lookahead", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, coordinateSpaceName: coordinateSpaceName, id: params.id, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    mgeNamespace: mgeNamespace,
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                DropRegion(
                    cardHovered: $cardHovered,
                    coordinateSpaceName: coordinateSpaceName,
                    id: params.id,
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct ChoiceOfCard<ParentTitles: View>: TitledCardView {
/// Pick a card, any card...
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: ChoiceOfParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var title: some View {
        DefaultTitle("Choice Of", symbol)
    }
    
    var contents: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, coordinateSpaceName: coordinateSpaceName, id: params.id, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
                    coordinateSpaceName: coordinateSpaceName,
                    path: path.appending(.child(index: index, subpath: .target)),
                    mgeNamespace: mgeNamespace,
                    parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                DropRegion(
                    cardHovered: $cardHovered,
                    coordinateSpaceName: coordinateSpaceName,
                    id: params.id,
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct AnchorCard<ParentTitles: View>: TitledCardView {
    
    let params: AnchorParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
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
