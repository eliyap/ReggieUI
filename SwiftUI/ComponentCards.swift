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
    
    @EnvironmentObject private var parameterConduit: ParameterConduit
    
    let params: StringParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        Grid {
            ParamString
        }
            /// Add padding since there aren't any component `DropRegion`s.
            .padding(.bottom, DropRegion.baseHeight / 2)
    }
    
    @State private var param_string: String = ""
    private let param_string_name = "Matched Text"
    private var ParamString: some View {
        GridRow {
            Text(param_string_name + ": ")
            TextField("", text: $param_string, prompt: Text("text to match"))
                .onAppear {
                    param_string = params.string
                }
                .onSubmit {
                    var params = params
                    params.string = param_string
                    parameterConduit.componentQueue.send((path, .string(params)))
                }
                .accessibilityLabel(param_string_name)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct ZeroOrMoreCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject private var parameterConduit: ParameterConduit
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: ZeroOrMoreParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack(spacing: .zero) {
            Grid {
                ParamBehavior
            }
            ComponentsView
        }
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RegexRepetitionBehavior = .default
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        GridRow {
            Text(param_behavior_name + ": ")
            Picker("", selection: $param_behavior) {
                ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RegexRepetitionBehavior) in
                    Text(behavior.displayTitle)
                }
            }
                .pickerStyle(.segmented)
                .accessibilityLabel(param_behavior_name)
                .onChange(of: param_behavior, perform: { behavior in
                    var params = params
                    params.behaviour = behavior
                    parameterConduit.componentQueue.send((path, .zeroOrMore(params)))
                })
        }
    }
}

struct OneOrMoreCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject private var parameterConduit: ParameterConduit
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: OneOrMoreParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    
    let insets = cardInsets
    
    var contents: some View {
        VStack(spacing: .zero) {
            Grid {
                ParamBehavior
            }
            ComponentsView
        }
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RegexRepetitionBehavior = .default
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        GridRow {
            Text(param_behavior_name + ": ")
            Picker("", selection: $param_behavior) {
                ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RegexRepetitionBehavior) in
                    Text(behavior.displayTitle)
                }
            }
                .pickerStyle(.segmented)
                .accessibilityLabel(param_behavior_name)
                .onChange(of: param_behavior, perform: { behavior in
                    var params = params
                    params.behaviour = behavior
                    parameterConduit.componentQueue.send((path, .oneOrMore(params)))
                })
        }
    }
}

struct OptionallyCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject private var parameterConduit: ParameterConduit
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: OptionallyParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    var contents: some View {
        VStack(spacing: .zero) {
            Grid {
                ParamBehavior
            }
            ComponentsView
        }
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RegexRepetitionBehavior = .default
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        GridRow {
            Text(param_behavior_name + ": ")
            Picker("", selection: $param_behavior) {
                ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RegexRepetitionBehavior) in
                    Text(behavior.displayTitle)
                }
            }
                .pickerStyle(.segmented)
                .accessibilityLabel(param_behavior_name)
                .onChange(of: param_behavior, perform: { behavior in
                    var params = params
                    params.behaviour = behavior
                    parameterConduit.componentQueue.send((path, .optionally(params)))
                })
        }
    }
}

struct RepeatCard<ParentTitles: View>: TitledCardView {
    
    @EnvironmentObject private var parameterConduit: ParameterConduit
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    let params: RepeatParameter
    let coordinateSpaceName: String
    let path: ModelPath
    let mgeNamespace: Namespace.ID
    let parentTitles: () -> ParentTitles
    
    let insets = cardInsets
    
    #warning("TODO: implement repeat range count UI")
    var contents: some View {
        VStack(spacing: .zero) {
            Grid {
                ParamBehavior
            }
            ComponentsView
        }
    }
    
    private var ComponentsView: some View {
        VStack(spacing: interCardSpacing) {
            DropRegion(cardHovered: $cardHovered, path: path.appending(.child(index: 0, subpath: .target)), relativeLocation: .top)
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
                    path: path.appending(.child(index: index + 1, subpath: .target)),
                    relativeLocation: model.id == params.components.last?.id
                        ? .bottom
                        : .middle
                )
            }
        }
    }
    
    @State private var param_behavior: RegexRepetitionBehavior = .default
    private let param_behavior_name = "Repetition"
    private var ParamBehavior: some View {
        GridRow {
            Text(param_behavior_name + ": ")
            Picker("", selection: $param_behavior) {
                ForEach([.reluctant, .eager, .possessive], id: \.self) { (behavior: RegexRepetitionBehavior) in
                    Text(behavior.displayTitle)
                }
            }
                .pickerStyle(.segmented)
                .accessibilityLabel(param_behavior_name)
                .onChange(of: param_behavior, perform: { behavior in
                    var params = params
                    params.behaviour = behavior
                    parameterConduit.componentQueue.send((path, .repeat(params)))
                })
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
    
    #warning("temporary")
    var contents: some View {
        Group {
            Text("params.boundary")
        }
    }
}
