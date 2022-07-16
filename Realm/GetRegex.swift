//
//  GetRegex.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 14/7/22.
//

import Foundation
import RealmSwift
import RegexModel

/// - Warning: By convention, do not capture the `RealmRegexModel` or `Realm` for use outside the clsure, this ensures object thread safety.
internal func withRegex<Output>(
    id: RealmRegexModel.ID,
    _ action: (Result<(RealmRegexModel, Realm), RealmDBError>) -> Output
) -> Output {
    action(getRegex(id: id))
}

/// - Warning: be very conscious of the thread on which this object lives
///            Where possible, *only* use the object within a single function call
fileprivate func getRegex(id: RealmRegexModel.ID) -> Result<(RealmRegexModel, Realm), RealmDBError> {
    guard let realm = try? Realm() else {
        return .failure(.couldNotOpenRealm)
    }
    
    guard let regex = realm.object(ofType: RealmRegexModel.self, forPrimaryKey: id) else {
        return .failure(.failedToFindObjectInRealm)
    }
    
    return .success((regex, realm))
}

/// Translates ID into Realm Object, then into SwiftUI friendly struct, reporting failures, if any.
/// Encapsulating within a function guarantees thread safety: no realm object crosses a boundary.
internal func regexIdToModel(id: RealmRegexModel.ID) -> Result<(RealmRegexModel.ID, ComponentsModel), RealmDBError> {
    withRegex(id: id) { result in
        switch result {
        case .failure(let error):
            return .failure(error)
        
        case .success((let model, _)):
            guard let components = try? JSONDecoder().decode([ComponentModel].self, from: model.componentsData) else {
                return .failure(.dataDecodeFailed)
            }
            
            return .success((model.id, .init(components: components)))
        }
    }
}

internal func save(components: [ComponentModel], to id: RealmRegexModel.ID) -> Result<Void, RealmDBError> {
    guard let data = try? JSONEncoder().encode(components) else {
        return .failure(.dataEncodeFailed)
    }

    return withRegex(id: id) { result in
        switch result {
        case .failure(let error):
            return .failure(error)
        
        case .success((let model, let realm)):
            do {
                try realm.writeWithToken { token in
                    model.componentsData = data
                }
                return .success(Void())
            } catch {
                return .failure(.writeFailed)
            }
        }
    }
}
