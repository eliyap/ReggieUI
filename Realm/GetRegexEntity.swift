//
//  GetRegexEntity.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 17/7/22.
//

import Foundation
import RegexModel

internal func getEntities(for identifiers: [RegexEntity.ID]) -> Result<[RegexEntity], RealmDBError> {
    withRegexes(ids: identifiers) { result in
        switch result {
        case .failure(let error):
            return .failure(error)
        
        case .success((let models, _)):
            var entities: [RegexEntity] = []
            
            for model in models {
                guard let components = try? JSONDecoder().decode([ComponentModel].self, from: model.componentsData) else {
                    return .failure(.dataDecodeFailed)
                }
                entities.append(RegexEntity(id: model.id, name: model.name, components: components))
            }
            
            return .success(entities)
        }
    }
}

internal func getSuggestedEntities(maxCount: Int, search: String? = nil) -> Result<[RegexEntity], RealmDBError> {
    return withSuggestedRegexes(maxCount: maxCount, search: search) { result in
        switch result {
        case .failure(let error):
            return .failure(error)
        
        case .success((let models, _)):
            var entities: [RegexEntity] = []
            
            for model in models {
                guard let components = try? JSONDecoder().decode([ComponentModel].self, from: model.componentsData) else {
                    return .failure(.dataDecodeFailed)
                }
                entities.append(RegexEntity(id: model.id, name: model.name, components: components))
            }
            
            return .success(entities)
        }
    }
}
