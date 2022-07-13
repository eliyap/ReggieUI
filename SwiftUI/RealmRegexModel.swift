//
//  File.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 11/7/22.
//

import Foundation
import RealmSwift
import RegexModel

final class RealmRegexModel: Object {
    /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
    /// > When declaring default values ... `@Persisted var value = UUID()` will result in poorer performance.
    /// > [It] creates a new identifier that is never used any time an object is read from the realm
    @Persisted(primaryKey: true)
    public var id: UUID
    
    /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
    /// > Data and string properties cannot hold more than 16MB.
    ///
    /// This limitation is left as future work, it's unlikely most regexes will exceed this size.
    @Persisted
    public var componentsData: Data
    
    public init(id: UUID, componentsData: Data) {
        super.init()
        self.id = UUID()
        self.componentsData = componentsData
    }
    
    override required init() {
        super.init()
    }
}

extension RealmRegexModel: Identifiable { }

internal extension RealmRegexModel {
    func from(_ memModel: ComponentsModel) throws -> RealmRegexModel {
        componentsData = try JSONEncoder().encode(memModel.components)
        
        /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
        /// > Data and string properties cannot hold more than 16MB.
        let mbCount = Double(componentsData.count) / (1024.0 * 1024.0)
        guard mbCount < 16.0 else { throw RealmDBError.dataTooLarge }
        
        return .init(
            id: memModel.id,
            componentsData: componentsData
        )
    }
}

internal extension ComponentsModel {
    func from(_ dbModel: RealmRegexModel) throws -> ComponentsModel {
        let components = try JSONDecoder().decode([ComponentModel].self, from: dbModel.componentsData)
        
        return .init(
            id: dbModel.id,
            components: components
        )
    }
}

public enum RealmDBError: LocalizedError {
    /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
    /// > Data and string properties cannot hold more than 16MB.
    ///
    /// This limitation is left as future work, it's unlikely most regexes will exceed this size.
    case dataTooLarge
    
    case couldNotOpen
    
    public var errorDescription: String? {
        switch self {
        case .dataTooLarge:
            return "Object too large to save in database"
        case .couldNotOpen:
            return "Couldn't open database"
        }
    }
}
