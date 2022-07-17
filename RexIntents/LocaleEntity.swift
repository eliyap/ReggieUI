//
//  LocaleEntity.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 17/7/22.
//

import AppIntents
import OrderedCollections

public struct LocaleEntity {
    public var id: String { identifier }
    
    /// Locale identifier, e.g `en_US`.
    public let identifier: String
    
    public static let currentLocaleIdentifier: String = "currentLocaleIdentifier"
    public static let currentLocaleTitle: String = "Current Locale"
}

// MARK: - AppEntity Conformance
extension LocaleEntity: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Locale"
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
    public static var defaultQuery = LocaleQuery()
    
    var title: String {
        if identifier == Self.currentLocaleIdentifier {
            return Self.currentLocaleTitle
        } else {
            return Locale(identifier: identifier).displayName() ?? "Unknown Locale"
        }
    }
}

public struct LocaleQuery: EntityQuery {
    
    /// - Note: > 100 elements causes SwiftUI to struggle, even on an M1 iPad Air.
    public static let maxResults = 50
    
    public typealias Entity = LocaleEntity
    public init() { }
    public func entities(for identifiers: [String]) async throws -> [LocaleEntity] {
        return identifiers.map { identifier in
            LocaleEntity(identifier: identifier)
        }
    }
    public func suggestedEntities() async throws -> [Entity] {
        /// Insert the special value and current locale first.
        var locales: OrderedDictionary<String, String> = [
            LocaleEntity.currentLocaleTitle: LocaleEntity.currentLocaleIdentifier,
        ]
        if let currentName = Locale.current.displayName() {
            locales[currentName] = Locale.current.identifier
        }
        
        /// Append to end of ordered dict, taking care not to overwrite.
        for (k, v) in orderedLocales where locales[k] == nil {
            locales[k] = v
        }
        
        return locales.values
            .prefix(Self.maxResults)
            .map { identifier in
                LocaleEntity(identifier: identifier)
            }
    }
    
    var orderedLocales: OrderedDictionary<String, String> {
        var locales: OrderedDictionary<String, String> = [:]
        for (k, v) in makeLocaleDictionary() {
            locales[k] = v
        }
        locales.sort { kv1, kv2 in
            return kv1.key < kv2.key
        }
        return locales
    }
}

extension LocaleQuery: EntityStringQuery {
    public func entities(matching string: String) async throws -> [Entity] {
        orderedLocales
            .filter { element in
                return element.key.localizedCaseInsensitiveContains(string) || element.value.localizedCaseInsensitiveContains(string)
            }
            .values
            .prefix(Self.maxResults)
            .map { identifier in
                LocaleEntity(identifier: identifier)
            }
    }
}
