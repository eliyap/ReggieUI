//
//  File.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 11/7/22.
//

import Foundation
import RealmSwift

final class RealmRegexModel: Object {
    /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
    /// > When declaring default values ... `@Persisted var value = UUID()` will result in poorer performance.
    /// > [It] creates a new identifier that is never used any time an object is read from the realm
    @Persisted(primaryKey: true)
    public var id: ID
    public typealias ID = UUID
    
    /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
    /// > Data and string properties cannot hold more than 16MB.
    ///
    /// This limitation is left as future work, it's unlikely most regexes will exceed this size.
    @Persisted
    public var componentsData: Data
    
    @Persisted
    public var name: String
    
    @Persisted
    public var lastUpdated: Date
    
    public init(id: UUID, componentsData: Data) {
        super.init()
        self.id = UUID()
        self.componentsData = componentsData
        self.name = "My Cool Regex"
        self.lastUpdated = Date()
    }
    
    override required init() {
        super.init()
    }
}

extension RealmRegexModel: Identifiable { }
