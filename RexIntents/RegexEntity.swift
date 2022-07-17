//
//  RegexEntity.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import AppIntents
import RealmSwift

/// The `AppIntents` representation of our model / database layer.
public struct RegexEntity {
    
    
    public let id: UUID
    public let name: String
}

// MARK: - AppEntity Conformance
extension RegexEntity: AppEntity {
    
    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Regular Expression"
    }
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    public static var defaultQuery: RegexQuery {
        .init()
    }
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
}
