//
//  RealmRegexModel.createNew.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 16/7/22.
//

import Foundation

/// - Note: needed for GUI, not for extension, hence broken into own file.
extension RealmRegexModel {
    public static func createNew() throws -> RealmRegexModel {
        let model = ComponentsModel(components: [])
        let componentsData = try JSONEncoder().encode(model.components)
        return .init(id: UUID(), componentsData: componentsData)
    }
}
