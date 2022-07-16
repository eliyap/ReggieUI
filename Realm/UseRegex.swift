//
//  UseRegex.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import Foundation
import RegexModel

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
