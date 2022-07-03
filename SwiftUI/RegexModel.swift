//
//  RegexModel.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 29/6/22.
//

import Combine
import RegexModel

final class _RegexModel: ObservableObject {
    
    @Published public var components: [ComponentModel]
    
    public init(components: [ComponentModel]) {
        self.components = components
    }
    
    public func regex() -> Regex<Substring> {
        components.regex()
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
