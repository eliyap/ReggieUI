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

    @Parameter(title: "Pattern")
    var pattern: RegexEntity
    
    @Parameter(title: "Text")
    var text: String
    
    public init() { }
    
    static public var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$pattern) in \(\.$text)")
    }
    
    public func perform() async throws -> some IntentResult {
        let regex = pattern.components.regex()
        let matches = try regex.allMatches(in: text)
        return .result(value: matches.map { String($0) })
    }
}
