//
//  RegexEntity.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import AppIntents
import RealmSwift
import RegexModel

/// The `AppIntents` representation of our model / database layer.
public struct RegexEntity {
    public let id: UUID
    public let name: String
    public let components: [ComponentModel]
}

// MARK: - AppEntity Conformance
extension RegexEntity: AppEntity {
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation = "Regular Expression"
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    public static var defaultQuery = RegexQuery()
}

public struct RegexQuery: EntityQuery {
    
    public typealias Entity = RegexEntity
    
    public init() { }
    
    public func entities(for identifiers: [Entity.ID]) async throws -> [Entity] {
        switch getEntities(for: identifiers) {
        case .failure(let error):
            throw error
        
        case .success(let entities):
            return entities
        }
    }
    
    public static let suggestionLimit = 1000
    public func suggestedEntities() async throws -> [Entity] {
        switch getSuggestedEntities(maxCount: Self.suggestionLimit) {
        case .failure(let error):
            throw error
            
        case .success(let entities):
            return entities
        }
    }
}

extension RegexQuery: EntityStringQuery {
    public func entities(matching string: String) async throws -> [Entity] {
        switch getSuggestedEntities(maxCount: Self.suggestionLimit, search: string) {
        case .failure(let error):
            throw error
            
        case .success(let entities):
            return entities
        }
    }
}
