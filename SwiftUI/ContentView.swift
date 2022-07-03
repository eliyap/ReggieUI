//
//  ContentView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import SwiftUI
import Combine
import RegexModel

struct RegexView: View {
    
    @StateObject private var params: _RegexModel = .init(components: _RegexModel.example)
    
    /// In case of multiple instances, ensure this is instance specific.
    private let coordinateSpaceName = UUID().uuidString
    
    @ObservedObject private var sheetInsetConduit: SheetInsetConduit
    
    @StateObject private var dropConduit: DropConduit = .init()
    
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    
    @Namespace private var mgeNamespace
    
    init(sheetInsetConduit: SheetInsetConduit) {
        self.sheetInsetConduit = sheetInsetConduit
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: interCardSpacing) {
                DropRegion(cardHovered: $cardHovered, path: .child(index: 0, subpath: .target), relativeLocation: .top)
                    /// - Note: giving an "invisible" border fixes an issue where these were not selectable.
                    .border(Color(uiColor: .systemBackground).opacity(0.01))
                ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                    ComponentView(
                        model: model,
                        coordinateSpaceName: coordinateSpaceName,
                        path: .child(index: index, subpath: .target),
                        mgeNamespace: mgeNamespace,
                        parentHeaders: EmptyView.init
                    )
                    DropRegion(
                        cardHovered: $cardHovered,
                        path: .child(index: index + 1, subpath: .target),
                        relativeLocation: model.id == params.components.last?.id
                            ? .bottom
                            : .middle
                    )
                        /// - Note: giving an "invisible" border fixes an issue where these were not selectable.
                        .border(Color(uiColor: .systemBackground).opacity(0.01))
                }
            }
                .environmentObject(dropConduit)
                .padding(Self.internalPadding)
                .onDrop(of: [.plainText], delegate: self)
                .coordinateSpace(name: DropConduit.scrollCoordinateSpace)
        }
            /// - Warning:
           /// When reducing sheet detent, scroll view does **NOT** move down if at bottom.
           /// Though we could fix this by moving the `safeAreaInset` inside the `ScrollView`,
           /// - it breaks hover-at-edge scrolling
           /// - it does not update the scroll bar insets
           .safeAreaInset(edge: .bottom, content: {
               Color.clear
                   .frame(height: sheetInsetConduit.sheetObscuringHeight)
           })
            .coordinateSpace(name: coordinateSpaceName)
            .background {
                BackgroundColor()
                    .ignoresSafeArea()
            }
            .onReceive(dropConduit.$dropPath) { output in
                guard let (id, path) = output else { return }
                params.move(id: id, to: path)
            }
    }
    
    public static let internalPadding: CGFloat = 30
}

extension RegexView: DropDelegate {
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        dropConduit.dropLocation = (info.location, .hover)
        return DropProposal(operation: .move)
    }
    
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
            
            DispatchQueue.main.async {
                dropConduit.dropLocation = (info.location, .drop(string as String))
                dropConduit.dropLocation = (nil, nil)
            }
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

internal final class DropConduit: ObservableObject {
    
    /// Identifier for named `CoordinateSpace`.
    public static let scrollCoordinateSpace: String = "DropConduitScrollCoordinateSpaceName"
    
    public enum Event {
        /// Corresponds to `dropUpdated`, when the user is still holding the item.
        case hover
        
        /// Corresponds `performDrop`, when the user drops the item.
        case drop(String)
    }
    
    /// Publishes locations & events passed from `DropDelegate`.
    @Published var dropLocation: (CGPoint?, Event?) = (nil, nil)
    
    @Published var dropPath: (id: String, ModelPath)? = nil
}
