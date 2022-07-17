//
//  GetRegexEntity.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 17/7/22.
//

import Foundation

internal func getEntities(for identifiers: [RegexEntity.ID]) -> Result<[RegexEntity], RealmDBError> {
    withRegexes(ids: identifiers) { result in
        switch result {
        case .failure(let error):
            return .failure(error)
        
        case .success((let models, _)):
            return .success(models.map { model in
                return RegexEntity(id: model.id, name: model.name)
            })
        }
    }
}
