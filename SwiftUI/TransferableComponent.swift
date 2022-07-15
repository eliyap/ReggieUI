//
//  TransferableComponent.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 15/7/22.
//

import Foundation
import UniformTypeIdentifiers

/// A custom drag'n'drop type.
final internal class TransferableComponent: NSObject {
    /// Exposes a single UniformTypeIdentifier as its interface.
    /// 
    /// Motivation: `NSString` can be drag'n'dropped, with `.plainText` as the UTI.
    /// However, as "text", any object dragged this way can enter other apps, our own text boxes, etc.
    /// A custom UTI avoids this over-permissive behavior.
    static let uti: String = "com.elijah.regexcomponent"
    
    /// Internal data representation is very simple.
    public let string: String
    
    public init(string: String) {
        self.string = string
    }
    
    enum Problem: Error {
        case unknownUti
    }
}

extension TransferableComponent: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        [Self.uti]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        guard typeIdentifier == Self.uti else {
            assert(false, "Unknown type identifier: \(typeIdentifier)")
            completionHandler(nil, Problem.unknownUti)
            return nil
        }
        
        completionHandler(Data(string.utf8), nil)
        return nil
    }
}

extension TransferableComponent: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [Self.uti]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        guard typeIdentifier == Self.uti else {
            assert(false, "Unknown type identifier: \(typeIdentifier)")
            throw Problem.unknownUti
        }
        
        let string = String(decoding: data, as: UTF8.self)
        return Self.init(string: string)
    }
}
