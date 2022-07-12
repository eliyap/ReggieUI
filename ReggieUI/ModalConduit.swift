//
//  ModalConduit.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 12/7/22.
//

import Combine

/// Controls which View Controller is presenting a modal, to avoid conflicts.
/// - Note: `ObservableObject` conformance lets us inject this as an `@EnvironmentObject`,
///         but this should not have `@Published` properties to avoid heavy view updates!
internal final class ModalConduit: ObservableObject {
    /// Indicates when the SwiftUI `UIHostingController` starts / stops presenting a modal.
    public let hostIsPresenting: PassthroughSubject<Bool, Never> = .init()
}
