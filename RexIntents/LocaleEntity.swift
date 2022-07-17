//
//  LocaleEntity.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 17/7/22.
//

import AppIntents

public struct LocaleEntity {
    public var id: String { identifier }
    
    /// Locale identifier, e.g `en_US`.
    public let identifier: String
}

// MARK: - AppEntity Conformance
extension LocaleEntity: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Locale"
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(Locale(identifier: identifier).displayName() ?? "Unknown Locale")")
    }
    public static var defaultQuery = LocaleQuery()
}

public struct LocaleQuery: EntityQuery {
    public typealias Entity = LocaleEntity
    public init() { }
    public func entities(for identifiers: [String]) async throws -> [LocaleEntity] {
        return identifiers.map { identifier in
            LocaleEntity(identifier: identifier)
        }
    }
    public func suggestedEntities() async throws -> [Entity] {
        makeLocaleDictionary().values
            .map { Locale(identifier: $0) }
            .filter { locale in
                guard let code = locale.languageCode else { return false }
                return Locale.commonLangCodes.contains(code)
            }
            .sorted(by: { locale1, locale2 in
                return (locale1.displayName() ?? "") < (locale2.displayName() ?? "")
            })
            .map { locale in
                LocaleEntity(identifier: locale.identifier)
            }
    }
}
