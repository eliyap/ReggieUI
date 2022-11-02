//
//  File.swift
//
//
//  Created by Secret Asian Man Dev on 17/7/22.
//

import Foundation

extension Locale {
    func displayName() -> String? {
        var name = ""
        
        /// Region name (like "United States")
        guard let region, let regionName = Locale.current.localizedString(forRegion: region) else {
            /// In testing, this *never* happened for ~1000 locales.
            Swift.debugPrint("No region for \(identifier)")
            return nil
        }
        name += regionName
        
        var langScript = ""
        
        /// Language name (like "English")
        if let languageCode, let lang = Locale.current.localizedString(forLanguageCode: languageCode) {
            langScript += lang
        }

        /// Script name (like "simplified chinese")
        if let scriptCode, let script = Locale.current.localizedString(forScriptCode: scriptCode) {
            if langScript.isEmpty == false { langScript += ", " }
            langScript += script
        }

        /// Append language information.
        if langScript.isEmpty == false {
            name += " (" + langScript + ")"
        }
        
        return name
    }
}

/// Maps human readable locale descriptions to locale codes.
/// e.g. `[China mainland (Chinese, Simplified Han): zh_Hans]`
/// Descriptions are localized to current locale.
func makeLocaleDictionary() -> [String: String] {
    var localeDictionary: [String: String] = [:]
    for code in Locale.availableIdentifiers {
        guard let localeName = Locale(identifier: code).displayName() else {
            continue
        }
        
        /// Check for a duplicate descriptor.
        if let oldCode = localeDictionary[localeName] {
            /// Often, we get a more specific locale, like `zh` vs `zh_Hans_CN`.
            /// In this case, defer to the more general locale.
            if oldCode.contains(code) {
                localeDictionary[localeName] = code
            } else if code.contains(oldCode) {
                localeDictionary[localeName] = oldCode
            } else {
                /// This only happened twiec in testing, for ~1000 locales.
                /// `no` vs `nb` vs `nb_NO` for "Norway (Norwegian Bokmål)"
                /// If the region, language, and script are the same, I expect similar results for most regexes.
                Swift.debugPrint("Duplicate region name: \(localeName) — \(code) vs \(oldCode)")
                
                /// Arbitrarily choose the lexically first code (typically shorter).
                if code < oldCode {
                    localeDictionary[localeName] = code
                } else {
                    localeDictionary[localeName] = oldCode
                }
            }
        }
        localeDictionary[localeName] = code
    }
    return localeDictionary
}

/// Run with `swift FILENAME` to check the output.
//func main() -> Void {
//
//    let localeDictionary = makeLocaleDictionary()
//    for (name, code) in localeDictionary {
//        print("\(name) — \(code)")
//    }
//
//    print("Done.")
//}
//
///// Calls the function globally in a way that the compiler won't complain about.
//fileprivate let workaround: Void = main()
