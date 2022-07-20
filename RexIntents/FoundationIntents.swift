//
//  FoundationIntents.swift
//  RexIntents
//
//  Created by Secret Asian Man Dev on 17/7/22.
//

import AppIntents

public struct DateIntent: AppIntent {
    public static var title: LocalizedStringResource = "Find Dates in Input"
    
    @Parameter(title: "Text")
    var text: String
    
    @Parameter(title: "Use Current Locale", default: true)
    var useCurrentLocale: Bool
    
    @Parameter(title: "Locale")
    var locale: LocaleEntity
    
    public init() { }
    
    public static var parameterSummary: some ParameterSummary {
        When(\Self.$useCurrentLocale, .equalTo, true) {
            Summary("Find dates in \(\.$text)") {
                \.$useCurrentLocale
            }
        } otherwise: {
            Summary("Find dates in \(\.$text)") {
                \.$useCurrentLocale
                \.$locale
            }
        }
    }
    
    public typealias PerformResult = IntentResultContainer<Date?, Never, Never, Never>
    public func perform() async throws -> PerformResult {
        let regex = Date.ParseStrategy.date(
            .abbreviated,
            locale: useCurrentLocale
                ? .current
                : Locale(identifier: locale.identifier),
            timeZone: .current
        )
        let match = try regex.regex.firstMatch(in: text)
        
        #warning("bugged?")
        let date: Date? = match?.output
        return .result(value: date)
    }
}

public struct CurrencyIntent: AppIntent {
    public static var title: LocalizedStringResource = "Find Currency in Input"
    
    @Parameter(title: "Text")
    var text: String
    
    @Parameter(title: "Use Current Locale", default: true)
    var useCurrentLocale: Bool
    
    @Parameter(title: "Locale")
    var locale: LocaleEntity
    
    public init() { }
    
    public static var parameterSummary: some ParameterSummary {
        When(\Self.$useCurrentLocale, .equalTo, true) {
            Summary("Find currency in \(\.$text)") {
                \.$useCurrentLocale
            }
        } otherwise: {
            Summary("Find currency in \(\.$text)") {
                \.$useCurrentLocale
                \.$locale
            }
        }
    }
    
    public typealias PerformResult = IntentResultContainer<[Double]?, Never, Never, Never>
    public func perform() async throws -> PerformResult {
        let locale = useCurrentLocale
            ? .current
            : Locale(identifier: self.locale.identifier)
        let regex = Decimal.FormatStyle.Currency.localizedCurrency(
            code: locale.currency ?? .unknown,
            locale: locale
        )
        
        let matches = try regex.regex.allMatches(in: text)
        if matches.isEmpty {
            return .result(value: nil)
        } else {
            let doubles = matches.map { decimal in
                return NSDecimalNumber(decimal: decimal).doubleValue
            }
            return .result(value: doubles)
        }
    }
}
