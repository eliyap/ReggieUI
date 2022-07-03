//
//  RegexModel.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 29/6/22.
//

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
    
    func move(id: String, to path: ModelPath) -> Void {
        
    }
}
