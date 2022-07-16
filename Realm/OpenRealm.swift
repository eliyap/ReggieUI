//
//  OpenRealm.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import Foundation
import RealmSwift

internal let AppGroupName = "group.elijah.regex"

/// - Warning: by convention, do not capture `Realm` for use outside closure, this ensures thread safe access.
internal func accessRealm<Output>(operation: (Result<Realm, RealmDBError>) -> Output) -> Output {
    return operation(openRealm())
}

fileprivate func openRealm() -> Result<Realm, RealmDBError> {
    guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupName) else {
        return .failure(.openAppGroupFailed)
    }
    let realmURL = appGroupURL.appendingPathComponent("default.realm")
    let config = Realm.Configuration(fileURL: realmURL)
    do {
        let realm = try Realm(configuration: config)
        return .success(realm)
    } catch {
        Swift.debugPrint("\(error)")
        return .failure(.couldNotOpenRealm)
    }
}
