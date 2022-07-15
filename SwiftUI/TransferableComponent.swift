//
//  TransferableComponent.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 15/7/22.
//

import Foundation
import UniformTypeIdentifiers

final internal class TransferableComponent: NSObject {
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
