//
//  RegexModel.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 29/6/22.
//

import SwiftUI
import Combine
import RegexModel
import Foundation

final class _RegexModel: ObservableObject {
    
    @Published public var components: [ComponentModel]
    
    public init(components: [ComponentModel]) {
        self.components = components
    }
    
    public func regex() -> Regex<Substring> {
        components.regex()
    }
    
    public func move(id: String, to target: ModelPath) -> Void {
        guard let sourcePath = path(id: id) else {
            Swift.debugPrint("Could not find path for ID \(id)")
            if UUID(uuidString: id) != nil { assert(false) }
            return
        }
        
        guard target.isSubpathOf(sourcePath) == false else {
            Swift.debugPrint("Cannot drop item into itself")
            return
        }
        
        withAnimation(Animation.jelly) {
            insert(self[sourcePath], at: target)
            delete(at: sourcePath.adjustedFor(insertionAt: target))
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
}

fileprivate extension Animation {
    /// A spring that produces a slight jelly wobble when landing.
    /// Overshoots about once, then returns.
    static let jelly: Animation = .spring(response: 0.3, dampingFraction: 0.7)
}

extension _RegexModel {
    subscript(_ path: ModelPath) -> ComponentModel {
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

extension _RegexModel {
    static let example: [ComponentModel] = [
        .oneOrMore(.init(components: [
            .zeroOrMore(.init(components: [
                .string(.init(string: "lmao")),
            ])),
            .optionally(.init(components: [])),
            .repeat(.init(range: 1..<2, components: [])),
        ])),
        .lookahead(.init(negative: false, components: [])),
        .choiceOf(.init(components: [
            .anchor(.init(boundary: .wordBoundary))
        ]))
    ]
}
