//
//  GetRegex.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 14/7/22.
//

import Foundation
import RealmSwift

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
