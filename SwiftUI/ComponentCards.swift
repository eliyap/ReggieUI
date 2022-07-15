//
//  ComponentCards.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 1/7/22.
//

import SwiftUI
import RegexBuilder
import RegexModel

struct StringCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: StringParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            ParamString
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    @State private var param_string: String = ""
    @FocusState private var string_focused: Bool
    private let param_string_name = "Matched Text"
    private var ParamString: some View {
        HStack {
            Text(param_string_name)
                .fontWeight(.medium)
            Spacer()
            TextField("", text: $param_string, prompt: Text("text"))
                .multilineTextAlignment(.trailing)
                .focused($string_focused)
                .onAppear {
                    param_string = params.string
                }
                .onChange(of: string_focused, perform: { isFocused in
                    if isFocused == false {
                        commit_string()
                    }
                })
                .onSubmit(commit_string)
                .accessibilityLabel(param_string_name)
        }
    }
    private func commit_string() -> Void {
        var params = params
        params.string = param_string
        parameterConduit.componentQueue.send(.set(path, .string(params)))
    }
}

struct ZeroOrMoreCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @EnvironmentObject private var modalConduit: ModalConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: ZeroOrMoreParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack(spacing: .zero) {
            ParamBehavior
                .padding(.trailing, cardInsets.trailing)
            ComponentsView
        }
            .padding(.top, DropRegion.baseHeight / 2)
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RepetitionBehavior = .default
    @State private var showBehaviorMenu: Bool = false
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        HStack {
            Text(param_behavior_name)
                .fontWeight(.medium)
            Spacer()
            Button(param_behavior.displayTitle) {
                modalConduit.hostIsPresenting.send(true)
                showBehaviorMenu = true
            }
                .onAppear {
                    param_behavior = params.behavior
                }
                .confirmationDialog(param_behavior_name, isPresented: $showBehaviorMenu, titleVisibility: .visible) {
                    ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RepetitionBehavior) in
                        Button(behavior.displayTitle) {
                            var params = params
                            params.behavior = behavior
                            parameterConduit.componentQueue.send(.set(path, .zeroOrMore(params)))
                            
                            param_behavior = behavior
                            modalConduit.hostIsPresenting.send(false)
                        }
                    }
                    /// - Note: explicitly providing and tagging this causes the closure to be called
                    ///         when the user taps *outside* the buttons to dismiss.
                    Button("Cancel", role: .cancel) {
                        showBehaviorMenu = false
                        modalConduit.hostIsPresenting.send(false)
                    }
                }
        }
    }
}

struct OneOrMoreCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @EnvironmentObject private var modalConduit: ModalConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: OneOrMoreParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    
    let insets = cardInsets
    
    var contents: some View {
        VStack(spacing: .zero) {
            ParamBehavior
                .padding(.trailing, cardInsets.trailing)
            ComponentsView
        }
            .padding(.top, DropRegion.baseHeight / 2)
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RepetitionBehavior = .default
    @State private var showBehaviorMenu: Bool = false
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        HStack {
            Text(param_behavior_name)
                .fontWeight(.medium)
            Spacer()
            Button(param_behavior.displayTitle) {
                modalConduit.hostIsPresenting.send(true)
                showBehaviorMenu = true
            }
                .onAppear {
                    param_behavior = params.behavior
                }
                .confirmationDialog(param_behavior_name, isPresented: $showBehaviorMenu, titleVisibility: .visible) {
                    ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RepetitionBehavior) in
                        Button(behavior.displayTitle) {
                            var params = params
                            params.behavior = behavior
                            parameterConduit.componentQueue.send(.set(path, .oneOrMore(params)))
                            
                            param_behavior = behavior
                            modalConduit.hostIsPresenting.send(false)
                        }
                    }
                    /// - Note: explicitly providing and tagging this causes the closure to be called
                    ///         when the user taps *outside* the buttons to dismiss.
                    Button("Cancel", role: .cancel) {
                        showBehaviorMenu = false
                        modalConduit.hostIsPresenting.send(false)
                    }
                }
        }
    }
}

struct OptionallyCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @EnvironmentObject private var modalConduit: ModalConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: OptionallyParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack(spacing: .zero) {
            ParamBehavior
                .padding(.trailing, cardInsets.trailing)
            ComponentsView
        }
            .padding(.top, DropRegion.baseHeight / 2)
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RepetitionBehavior = .default
    @State private var showBehaviorMenu: Bool = false
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        HStack {
            Text(param_behavior_name)
                .fontWeight(.medium)
            Spacer()
            Button(param_behavior.displayTitle) {
                modalConduit.hostIsPresenting.send(true)
                showBehaviorMenu = true
            }
                .onAppear {
                    param_behavior = params.behavior
                }
                .confirmationDialog(param_behavior_name, isPresented: $showBehaviorMenu, titleVisibility: .visible) {
                    ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RepetitionBehavior) in
                        Button(behavior.displayTitle) {
                            var params = params
                            params.behavior = behavior
                            parameterConduit.componentQueue.send(.set(path, .optionally(params)))
                            
                            param_behavior = behavior
                            modalConduit.hostIsPresenting.send(false)
                        }
                    }
                    /// - Note: explicitly providing and tagging this causes the closure to be called
                    ///         when the user taps *outside* the buttons to dismiss.
                    Button("Cancel", role: .cancel) {
                        showBehaviorMenu = false
                        modalConduit.hostIsPresenting.send(false)
                    }
                }
        }
    }
}

struct RepeatCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @EnvironmentObject private var modalConduit: ModalConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: RepeatParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    #warning("TODO: implement repeat range count UI")
    var contents: some View {
        VStack(spacing: .zero) {
            ParamBehavior
                .padding(.trailing, cardInsets.trailing)
            ComponentsView
        }
            .padding(.top, DropRegion.baseHeight / 2)
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RepetitionBehavior = .default
    @State private var showBehaviorMenu: Bool = false
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        HStack {
            Text(param_behavior_name)
                .fontWeight(.medium)
            Spacer()
            Button(param_behavior.displayTitle) {
                modalConduit.hostIsPresenting.send(true)
                showBehaviorMenu = true
            }
                .onAppear {
                    param_behavior = params.behavior
                }
                .confirmationDialog(param_behavior_name, isPresented: $showBehaviorMenu, titleVisibility: .visible) {
                    ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RepetitionBehavior) in
                        Button(behavior.displayTitle) {
                            var params = params
                            params.behavior = behavior
                            parameterConduit.componentQueue.send(.set(path, .repeat(params)))
                            
                            param_behavior = behavior
                            modalConduit.hostIsPresenting.send(false)
                        }
                    }
                    /// - Note: explicitly providing and tagging this causes the closure to be called
                    ///         when the user taps *outside* the buttons to dismiss.
                    Button("Cancel", role: .cancel) {
                        showBehaviorMenu = false
                        modalConduit.hostIsPresenting.send(false)
                    }
                }
        }
    }
}

struct LookaheadCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: LookaheadParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {VStack {
            ComponentsView
        }
    }

    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
}

struct NegativeLookaheadCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: NegativeLookaheadParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {VStack {
            ComponentsView
        }
    }

    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: ChoiceOfParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack {
            ComponentsView
        }
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
            ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                ComponentView(
                    model: model,
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
    
    @EnvironmentObject internal var parameterConduit: ParameterConduit
    @EnvironmentObject private var modalConduit: ModalConduit
    @Environment(\.scrollCoordinateSpaceName) var coordinateSpaceName
    
    let params: AnchorParameter
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    #warning("temporary")
    var contents: some View {
        VStack {
            ParamBoundary
                .padding(.trailing, cardInsets.trailing)
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.vertical, DropRegion.baseHeight / 2)
    }
    
    @State private var param_boundary: AnchorParameter.Boundary = .default
    @State private var showBoundaryMenu: Bool = false
    private let param_boundary_name = "Boundary"
    private var ParamBoundary: some View {
        HStack {
            Text(param_boundary_name)
                .fontWeight(.medium)
            Spacer()
            Button(param_boundary.displayTitle) {
                modalConduit.hostIsPresenting.send(true)
                showBoundaryMenu = true
            }
                .onAppear {
                    param_boundary = params.boundary
                }
                .confirmationDialog(param_boundary_name, isPresented: $showBoundaryMenu, titleVisibility: .visible) {
                    ForEach(AnchorParameter.Boundary.allCases, id: \.self) { boundary in
                        Button(boundary.displayTitle) {
                            var params = params
                            params.boundary = boundary
                            parameterConduit.componentQueue.send(.set(path, .anchor(params)))
                            
                            param_boundary = boundary
                            modalConduit.hostIsPresenting.send(false)
                        }
                    }
                    /// - Note: explicitly providing and tagging this causes the closure to be called
                    ///         when the user taps *outside* the buttons to dismiss.
                    Button("Cancel", role: .cancel) {
                        showBoundaryMenu = false
                        modalConduit.hostIsPresenting.send(false)
                    }
                }
        }
    }
}
