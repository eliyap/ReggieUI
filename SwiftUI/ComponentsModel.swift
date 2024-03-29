//
//  ComponentsModel.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 29/6/22.
//

import SwiftUI
import Combine
import RegexModel
import Foundation

/// Represents the "guts" of our Regex DSL abstraction: the components.
/// Though this does not conform to `ComponentModel`, it intentionally shares most of the API.
final class ComponentsModel: ObservableObject {
    
    @Published public var components: [ComponentModel]
    
    public init(components: [ComponentModel]) {
        self.components = components
    }
}

// MARK: - Component Mutation
extension ComponentsModel {
    
    public func regex() -> Regex<Substring> {
        components.regex()
    }
    
    public func move(_ string: String, to target: ModelPath) -> Void {
        if let sourcePath = path(id: string) {
            guard target.isSubpathOf(sourcePath) == false else {
                Swift.debugPrint("Cannot drop item into itself")
                return
            }
            
            withAnimation(Animation.jelly) {
                insert(self[sourcePath], at: target)
                delete(at: sourcePath.adjustedFor(insertionAt: target))
            }
        } else if let proxy = ComponentModel.Proxy(rawValue: string) {
            withAnimation(Animation.jelly) {
                insert(proxy.createNew(), at: target)
            }
        } else {
            Swift.debugPrint("Could not resolve \(string)")
            if UUID(uuidString: string) != nil { assert(false) }
            return
        }
    }
    
    private func path(id: String) -> ModelPath? {
        for (idx, component) in components.enumerated() {
            guard let subPath = component.path(for: id) else { continue }
            return .child(index: idx, subpath: subPath)
        }
        
        return nil
    }
    
    private func insert(_ component: ComponentModel, at path: ModelPath) -> Void {
        /// Should always be handled by parents or grandparents, never the child directly.
        guard case .child(let index, let subpath) = path else {
            assert(false, "Illegal state")
        }
        
        switch subpath {
        case .target:
            components.insert(component, at: index)
        
        case .child:
            components[index].insert(component, at: subpath)
        }
    }
    
    private func delete(at path: ModelPath) -> Void {
        guard case .child(let index, let subpath) = path else {
            assert(false, "Should be handled by parent")
            return
        }

        switch subpath {
        case .target:
            components.remove(at: index)
        case .child:
            components[index].delete(at: subpath)
        }
    }
    
    internal subscript(_ path: ModelPath) -> ComponentModel {
        get {
            guard case .child(let index, let subpath) = path else {
                fatalError("Cannot target model directly")
            }
            return components[index][subpath]
        }
        set {
            guard case .child(let index, let subpath) = path else {
                fatalError("Cannot target model directly")
            }
            return components[index][subpath] = newValue
        }
    }
}

extension ComponentsModel {
    internal func execute(_ action: ParameterConduit.Action) -> Void {
        switch action {
        case .delete(let path):
            withAnimation(.jelly) {
                delete(at: path)
            }
        case .set(let path, let component):
            self[path] = component
        }
    }
}

// MARK: - Misc
extension ComponentsModel {
    static let example: [ComponentModel] = [
//        .oneOrMore(.init(components: [
//            .zeroOrMore(.init(components: [
//                .string(.init(string: "lmao")),
//            ])),
//            .optionally(.init(components: [])),
//            .repeat(.init(range: 1..<2, components: [])),
//        ])),
//        .lookahead(.init(components: [])),
//        .choiceOf(.init(components: [
//            .anchor(.init(boundary: .wordBoundary))
//        ]))
    ]
    #warning("debug the above, it might be an infinite regex!!!")
    
//    static let example: [ComponentModel] = [
//        .optionally(.init(components: [
//            .string(.init(string: "s")),
//        ])),
//        .string(.init(string: "car")),
//        .anchor(.init(boundary: .wordBoundary)),
//    ]
}

fileprivate extension Animation {
    /// A spring that produces a slight jelly wobble when landing.
    /// Overshoots about once, then returns.
    static let jelly: Animation = .spring(response: 0.3, dampingFraction: 0.7)
}

