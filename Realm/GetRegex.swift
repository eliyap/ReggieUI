//
//  GetRegex.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 14/7/22.
//

import Foundation
import RealmSwift
import RegexModel

/// - Warning: be very conscious of the thread on which this object lives!
internal func getRegex(id: RealmRegexModel.ID) -> Result<RealmRegexModel, RealmDBError> {
    guard let realm = try? Realm() else {
        return .failure(.couldNotOpenRealm)
    }
    
    guard let regex = realm.object(ofType: RealmRegexModel.self, forPrimaryKey: id) else {
        return .failure(.failedToFindObjectInRealm)
    }
    
    return .success(regex)
}

/// Translates ID into Realm Object, then into SwiftUI friendly struct, reporting failures, if any.
/// Encapsulating within a function guarantees thread safety: no realm object crosses a boundary.
internal func regexIdToModel(id: RealmRegexModel.ID) -> Result<(RealmRegexModel.ID, ComponentsModel), RealmDBError> {
    let regex: RealmRegexModel
    switch getRegex(id: id) {
    case .success(let r):
        regex = r
    case .failure(let error):
        return .failure(error)
    }
    
    guard let components = try? JSONDecoder().decode([ComponentModel].self, from: regex.componentsData) else {
        return .failure(.dataDecodeFailed)
    }
    
    return .success((regex.id, .init(components: components)))
}

internal func save(components: [ComponentModel], to id: RealmRegexModel.ID) -> Result<Void, RealmDBError> {
    guard let realm = try? Realm() else {
        return .failure(.couldNotOpenRealm)
    }
    
    let regex: RealmRegexModel
    switch getRegex(id: id) {
    case .failure(let error):
        return .failure(error)
    case .success(let r):
        regex = r
    }
    
    guard let data = try? JSONEncoder().encode(components) else {
        return .failure(.dataEncodeFailed)
    }
    
    do {
        try realm.writeWithToken { token in
            regex.componentsData = data
        }
    } catch {
        return .failure(.writeFailed)
    }
    
    return .success(Void())
}
