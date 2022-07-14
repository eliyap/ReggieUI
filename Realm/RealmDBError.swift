//
//  RealmDBError.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 14/7/22.
//

import Foundation

public enum RealmDBError: LocalizedError {
    /// Via the docs: https://www.mongodb.com/docs/realm/sdk/swift/data-types/supported-property-types/
    /// > Data and string properties cannot hold more than 16MB.
    ///
    /// This limitation is left as future work, it's unlikely most regexes will exceed this size.
    case dataTooLarge
    
    case couldNotOpenRealm
    
    case writeFailed
    
    case createNewObjectFailed
    
    case failedToFindObjectInRealm
    
    case dataDecodeFailed
    
    public var errorDescription: String? {
        switch self {
        case .dataTooLarge:
            return "Object too large to save in database"
        case .couldNotOpenRealm:
            return "Couldn't open database"
        case .writeFailed:
            return "Couldn't write to database"
        case .createNewObjectFailed:
            return "Couldn't make a new object"
        case .failedToFindObjectInRealm:
            return "Couldn't find an object"
        case .dataDecodeFailed:
            return "Couldn't deode object"
        }
    }
}
