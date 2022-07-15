//
//  DropRegionKey.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 10/7/22.
//

import SwiftUI
import RegexModel

/// Allows the top level view to monitor the locations of all cards.
/// This helps determine where drops should go.
struct DropRegionKey: PreferenceKey {
    static var defaultValue: [ModelPath: CGRect] = [:]
    
    static func reduce(value: inout [ModelPath : CGRect], nextValue: () -> [ModelPath : CGRect]) {
        value.merge(nextValue()) { (current, new) in
            return new
        }
    }
}
