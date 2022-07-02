//
//  ContentView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import SwiftUI
import Combine

struct RegexView: View {
    
    @StateObject private var model: _RegexModel = .init(components: _RegexModel.example)
    
    /// In case of multiple instances, ensure this is instance specific.
    private let coordinateSpaceName = UUID().uuidString
    
    @ObservedObject private var sheetInsetConduit: SheetInsetConduit
    
    init(sheetInsetConduit: SheetInsetConduit) {
        self.sheetInsetConduit = sheetInsetConduit
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: interCardSpacing) {
                ForEach(model.components) { component in
                    ComponentView(
                        model: component,
                        coordinateSpaceName: coordinateSpaceName,
                        parentHeaders: EmptyView.init
                    )
                }
            }
                .padding(Self.internalPadding)
                .safeAreaInset(edge: .bottom, content: {
                    Color.clear
                        .frame(height: sheetInsetConduit.sheetObscuringHeight)
                })
                .onDrop(of: [.plainText], delegate: self)
        }
            .coordinateSpace(name: coordinateSpaceName)
            .background {
                BackgroundColor()
                    .ignoresSafeArea()
            }
    }
    
    public static let internalPadding: CGFloat = 30
}

extension RegexView: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let providers = info.itemProviders(for: [.plainText])
        guard providers.count == 1 else {
            Swift.debugPrint("Wrong item count \(providers.count)")
            return false
        }
        
        let provider = providers[0]
        guard provider.canLoadObject(ofClass: NSString.self) else {
            Swift.debugPrint("Could not load string")
            return false
        }
        
        provider.loadObject(ofClass: NSString.self) { object, error in
            if let error {
                assert(false, error.localizedDescription)
                return
            }
            
            guard let string = object as? NSString else {
                assert(false, "Unexpected type!")
                return
            }
            
            print("id", string)
        }
        
        return true
    }
}

extension RegexView {
    fileprivate struct BackgroundColor: View {
            
        @Environment(\.colorScheme) private var colorScheme
        
        var body: some View {
            switch colorScheme {
            case .dark:
                Color(uiColor: .systemBackground)
            case .light:
                Color(uiColor: .secondarySystemBackground)
            @unknown default:
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }
}
