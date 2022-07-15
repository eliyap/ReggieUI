//
//  FoundationCards.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 10/7/22.
//

import SwiftUI
import RegexBuilder
import RegexModel

struct DateTimeCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: DateTimeParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}

struct CurrencyCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: CurrencyParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}

struct DecimalCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: DecimalParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}

struct WholeNumberCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: WholeNumberParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}

struct DecimalPercentageCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: DecimalPercentageParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}

struct WholeNumberPercentageCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: WholeNumberPercentageParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}

struct URLCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: URLParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            EmptyView()
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    #warning("TODO: add params")
}
