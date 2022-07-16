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

    @Parameter(title: "Text")
    var text: String
    
    #warning("replace with real pattern")
    #warning("look into default value argument")
    @Parameter(title: "Pattern")
    var pattern: String
    
    public init() { }
    
    static public var parameterSummary: some ParameterSummary {
        Summary("Check if \(\.$text) matches \(\.$pattern)")
    }
    
    public func perform() async throws -> some IntentResult {
        #warning("todo: return app entity matches?")
        return .result(value: "Hello World")
    }
}

public struct FindMatchesIntent: AppIntent {
    public static var title: LocalizedStringResource = "Find Matches in Text"

    @Parameter(title: "Number of Matches", default: MatchMode.first)
    var matchMode: MatchMode
    
    #warning("replace with real pattern")
    #warning("look into default value argument")
    @Parameter(title: "Pattern")
    var pattern: String
    
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
