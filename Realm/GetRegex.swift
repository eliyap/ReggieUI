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
