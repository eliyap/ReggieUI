//
//  DropConduit.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 10/7/22.
//

import SwiftUI
import Combine
import RegexModel

internal final class DropConduit: ObservableObject {
    
    /// Identifier for named `CoordinateSpace`.
    public static let scrollCoordinateSpace: String = "DropConduitScrollCoordinateSpaceName"
    
    /// Publishes locations & events passed from `DropDelegate`.
    @Published var dropLocation: CGPoint? = nil
}

/// - Note: `ObservableObject` conformance lets us inject this as an `@EnvironmentObject`,
///         but this should not have `@Published` properties to avoid heavy view updates!
internal final class ParameterConduit: ObservableObject {
    
    enum Action {
        case set(ModelPath, ComponentModel)
        case delete(ModelPath)
    }
    
    /// Pipeline for requesting changes to the model.
    public let componentQueue: PassthroughSubject<Action, Never> = .init()
}
