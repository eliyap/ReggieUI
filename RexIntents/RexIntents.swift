//
//  RexIntents.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import AppIntents
import RealmSwift

public struct WholeMatchIntent: AppIntent {
    public static var title: LocalizedStringResource = "Match Entire Text"
    public typealias PerformResult = IntentResultContainer<Bool, Never, Never, Never>
    
    @Parameter(title: "Text")
    var text: String
    
    @Parameter(title: "Pattern")
    var pattern: RegexEntity
    
    public init() { }
    
    static public var parameterSummary: some ParameterSummary {
        Summary("Check if \(\.$text) matches \(\.$pattern)")
    }
    
    public func perform() async throws -> PerformResult {
        let regex = pattern.components.regex()
        let match = try regex.wholeMatch(in: text)
        return .result(value: match != nil)
    }
}

public struct FindMatchesIntent: AppIntent {
    public static var title: LocalizedStringResource = "Find Matches in Text"

    @Parameter(title: "Number of Matches", default: MatchMode.first)
    var matchMode: MatchMode
    
    @Parameter(title: "Pattern")
    var pattern: RegexEntity
    
    @Parameter(title: "Text")
    var text: String
    
    public init() { }
    
    static public var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$matchMode) of \(\.$pattern) in \(\.$text)")
    }
    
    public func perform() async throws -> some IntentResult {
        #warning("todo: return app entity matches?")
        return .result(value: "Hello World")
    }
}

public enum MatchMode: String, RawRepresentable {
    case first
    case all
}

extension MatchMode: AppEnum {
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Number of Matches"
    
    public static var caseDisplayRepresentations: [MatchMode : DisplayRepresentation] = [
        .first: "first match",
        .all: "all matches",
    ]
}
