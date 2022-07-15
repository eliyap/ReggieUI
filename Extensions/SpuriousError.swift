//
//  SpuriousError.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 12/7/22.
//

import Foundation

/// An error which can be thrown in development to test error handling.
internal enum SpuriousError: LocalizedError {
    case problem
    
    var errorDescription: String? {
        switch self {
        case .problem:
            return "Developer Testing Error"
        }
    }
}
