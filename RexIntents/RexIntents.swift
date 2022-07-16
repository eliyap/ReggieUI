//
//  RexIntents.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import AppIntents
import RealmSwift

public struct RexIntent: AppIntent {
    public static var title: LocalizedStringResource = "RexIntents"

    public init() { }

    public func perform() async throws -> some IntentResult {
        return .result(value: "Hello World")
    }
}
