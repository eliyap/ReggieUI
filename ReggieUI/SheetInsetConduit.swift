//
//  SheetInsetConduit.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 12/7/22.
//

import SwiftUI

/// App's `Combine` based nervous system for event passing.
final class SheetInsetConduit: ObservableObject {
    /// The amount of height that the sheet is obscuring of the view behind.
    @Published public var sheetObscuringHeight: CGFloat = .zero
}
