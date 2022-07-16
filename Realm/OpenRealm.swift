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

internal func getOptionalConfiguration() -> Realm.Configuration? {
    switch getConfiguration() {
    case .failure(let error):
        assert(false, "\(error)")
        return nil
    
    case .success(let config):
        return config
    }
}

internal func getConfiguration() -> Result<Realm.Configuration, RealmDBError> {
    guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AppGroupName) else {
        return .failure(.openAppGroupFailed)
    }
    let realmURL = appGroupURL.appendingPathComponent("default.realm")
    let config = Realm.Configuration(fileURL: realmURL)
    return .success(config)
}

fileprivate func openRealm() -> Result<Realm, RealmDBError> {
    switch getConfiguration() {
    case .failure(let error):
        return .failure(error)
    
    case .success(let config):
        do {
            let realm = try Realm(configuration: config)
            return .success(realm)
        } catch {
            Swift.debugPrint("\(error)")
            return .failure(.couldNotOpenRealm)
        }
    }
}
