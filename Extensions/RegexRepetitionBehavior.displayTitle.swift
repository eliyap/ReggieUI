//
//  RegexRepetitionBehavior.displayTitle.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 4/7/22.
//

import RegexBuilder

extension RegexRepetitionBehavior {
    var displayTitle: String {
        switch self {
        case .reluctant:
            return "Reluctant"
        case .eager:
            return "Eager"
        case .possessive:
            return "Possessive"
        default:
            assert(false, "Unknown behavior case")
            return "Unknown"
        }
    }
}
