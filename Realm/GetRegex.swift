//
//  GetRegex.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 14/7/22.
//

import Foundation
import RealmSwift
import RegexModel

/// - Warning: By convention, do not capture the `RealmRegexModel` or `Realm` for use outside the closure, this ensures object thread safety.
internal func withRegex<Output>(
    id: RealmRegexModel.ID,
    _ action: (Result<(RealmRegexModel, Realm), RealmDBError>) -> Output
) -> Output {
    return action(getRegex(id: id))
}

/// - Warning: be very conscious of the thread on which this object lives
///            Where possible, *only* use the object within a single function call
fileprivate func getRegex(id: RealmRegexModel.ID) -> Result<(RealmRegexModel, Realm), RealmDBError> {
    return accessRealm { realm in
        guard let regex = realm.object(ofType: RealmRegexModel.self, forPrimaryKey: id) else {
            return .failure(.failedToFindObjectInRealm)
        }
        
        /// - Note: a specific exception to not returning the `Realm`, since this is another temp-access closure.
        return .success((regex, realm))
    }
}

/// - Warning: By convention, do not capture the `RealmRegexModel` or `Realm` for use outside the closure, this ensures object thread safety.
internal func withRegexes<Output>(
    ids: [RealmRegexModel.ID],
    _ action: (Result<([RealmRegexModel], Realm), RealmDBError>) -> Output
) -> Output {
    return action(getRegexes(ids: ids))
}

/// - Warning: be very conscious of the thread on which this object lives
///            Where possible, *only* use the object within a single function call
fileprivate func getRegexes(ids: [RealmRegexModel.ID]) -> Result<([RealmRegexModel], Realm), RealmDBError> {
    return accessRealm { realm in
        var models: [RealmRegexModel] = []
        for id in ids {
            guard let regex = realm.object(ofType: RealmRegexModel.self, forPrimaryKey: id) else {
                return .failure(.failedToFindObjectInRealm)
            }
            models.append(regex)
        }
        
        
        /// - Note: a specific exception to not returning the `Realm`, since this is another temp-access closure.
        return .success((models, realm))
    }
}
