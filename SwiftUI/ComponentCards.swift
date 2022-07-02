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
    let parentTitles: () -> ParentTitles
    
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
    let parentTitles: () -> ParentTitles
    
    var title: some View {
        DefaultTitle("Zero Or More", symbol)
    }
    
    var contents: some View {
        VStack(alignment: .trailing, spacing: interCardSpacing) {
            ForEach(params.components) { model in
                ComponentView(model: model, coordinateSpaceName: coordinateSpaceName, parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                
                DropRegion()
            }
        }
    }
}

struct OneOrMoreCard<ParentTitles: View>: TitledCardView {
    
    let params: OneOrMoreParameter
    let coordinateSpaceName: String
    let parentTitles: () -> ParentTitles
    
    var title: some View {
        DefaultTitle("One Or More", symbol)
    }
    
    var contents: some View {
        VStack(alignment: .trailing, spacing: interCardSpacing) {
            ForEach(params.components) { model in
                ComponentView(model: model, coordinateSpaceName: coordinateSpaceName, parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                
                DropRegion()
            }
        }
    }
}

struct OptionallyCard<ParentTitles: View>: TitledCardView {
    
    let params: OptionallyParameter
    let coordinateSpaceName: String
    let parentTitles: () -> ParentTitles
    
    var title: some View {
        DefaultTitle("Optionally", symbol)
    }
    
    var contents: some View {
        VStack(alignment: .trailing, spacing: interCardSpacing) {
            ForEach(params.components) { model in
                ComponentView(model: model, coordinateSpaceName: coordinateSpaceName, parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                
                DropRegion()
            }
        }
    }
}

struct RepeatCard<ParentTitles: View>: TitledCardView {
    
    let params: RepeatParameter
    let coordinateSpaceName: String
    let parentTitles: () -> ParentTitles
    
    var title: some View {
        DefaultTitle("Repeat", symbol)
    }
    
    var contents: some View {
        VStack(alignment: .trailing, spacing: interCardSpacing) {
            ForEach(params.components) { model in
                ComponentView(model: model, coordinateSpaceName: coordinateSpaceName, parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                
                DropRegion()
            }
        }
    }
}

struct LookaheadCard<ParentTitles: View>: TitledCardView {
    
    let params: LookaheadParameter
    let coordinateSpaceName: String
    let parentTitles: () -> ParentTitles
    
    var title: some View {
        DefaultTitle("Lookahead", symbol)
    }
    
    var contents: some View {
        VStack(alignment: .trailing, spacing: interCardSpacing) {
            ForEach(params.components) { model in
                ComponentView(model: model, coordinateSpaceName: coordinateSpaceName, parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                
                DropRegion()
            }
        }
    }
}

struct ChoiceOfCard<ParentTitles: View>: TitledCardView {
/// Pick a card, any card...
    
    let params: ChoiceOfParameter
    let coordinateSpaceName: String
    let parentTitles: () -> ParentTitles
    
    var title: some View {
        DefaultTitle("Choice Of", symbol)
    }
    
    var contents: some View {
        VStack(alignment: .trailing, spacing: interCardSpacing) {
            ForEach(params.components) { model in
                ComponentView(model: model, coordinateSpaceName: coordinateSpaceName, parentHeaders: {
                    VStack(spacing: .zero) {
                        parentTitles()
                        title
                    }
                })
                
                DropRegion()
            }
        }
    }
}

struct AnchorCard<ParentTitles: View>: TitledCardView {
    
    let params: AnchorParameter
    let coordinateSpaceName: String
    let parentTitles: () -> ParentTitles
    
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
