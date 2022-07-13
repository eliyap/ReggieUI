//
//  RegexView.swift
//  StickyScroll
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import SwiftUI
import Combine
import RegexModel

struct RegexView: View {
    
    /// In case of multiple instances, ensure this is instance specific.
    private let scrollCoordinateSpaceName = UUID().uuidString
    
    @StateObject private var dropConduit: DropConduit = .init()
    @StateObject private var parameterConduit: ParameterConduit = .init()
    @State private var cardHovered: DropRegion.RelativeLocation? = nil
    @State private var cardLocations: DropRegionKey.Value = [:]
    @Namespace private var mgeNamespace
    
    @ObservedObject public var sheetInsetConduit: SheetInsetConduit
    @ObservedObject public var params: _RegexModel
    public let modalConduit: ModalConduit
    
    var body: some View {
        ScrollView {
            VStack(spacing: interCardSpacing) {
                DropRegion(cardHovered: $cardHovered, path: .child(index: 0, subpath: .target), relativeLocation: .top)
                    /// - Note: giving an "invisible" border fixes an issue where these were not selectable.
                    .border(Color(uiColor: .systemBackground).opacity(0.01))
                ForEach(Array(params.components.enumerated()), id: \.element.id) { index, model in
                    ComponentView(
                        model: model,
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
                .environmentObject(parameterConduit)
                .environmentObject(modalConduit)
                .padding(Self.internalPadding)
                .onDrop(of: [.plainText], delegate: self)
                .coordinateSpace(name: DropConduit.scrollCoordinateSpace)
                #if DEBUG
//                .border(Color.blue, width: 3)
                #endif
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
            .coordinateSpace(name: scrollCoordinateSpaceName)
            .scrollCoordinateSpaceName(scrollCoordinateSpaceName)
            .background {
                BackgroundColor()
                    .ignoresSafeArea()
            }
            .onReceive(parameterConduit.componentQueue, perform: { output in
                let (path, component) = output
                params[path] = component
            })
            .onPreferenceChange(DropRegionKey.self) { dict in
                cardLocations = dict
            }
    }
    
    public static let internalPadding: CGFloat = 30
}

extension RegexView: DropDelegate {
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        dropConduit.dropLocation = info.location
        return DropProposal(operation: .copy)
    }
    
    func dropExited(info: DropInfo) {
        dropConduit.dropLocation = nil
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
                params.move(string as String, to: closestInsertionPath(to: info.location))
                dropConduit.dropLocation = nil
            }
        }
        
        return true
    }
}

/// - Note: We want to avoid pointer lookups (on `indirect enum`).
///         So we use a lot of geometry assumptions to skip path comparisons.
extension RegexView {
    /// Find the frames which represent direct children of this frame.
    fileprivate func findChildFramesOf(_ parent: ModelPath) -> [CGRect] {
        var result = cardLocations
        
        /// Top level clearly contains all frames. If not top level, filter for descendants.
        if parent != .target {
            guard let parentRect = cardLocations[parent] else {
                assert(false, "Must pass an existing path!")
                return []
            }
            result = result.filter { parentRect.contains($0.value.origin) }
            
            /// Remove self from contention, to be safe.
            result[parent] = nil
        }
        
        /// Remove any descendants contained by any *other* descendants.
        let removalTargets = result.keys.filter { key in
            let candidatePoint = result[key]!.origin
            return result.contains(where: {
                ($0.key != key) && ($0.value.contains(candidatePoint))
            })
        }
        removalTargets.forEach { result[$0] = nil }
        
        return Array(result.values)
    }
    
    fileprivate func findPath(parent: ModelPath, point: CGPoint) -> ModelPath {
        let children = findChildFramesOf(parent)
            /// Sort visually, as a proxy for actual path ordering.
            .sorted(by: { $0.origin.y < $1.origin.y })
        
        /// Assertions.
        if parent != .target {
            guard let parentRect = cardLocations[parent] else {
                assert(false, "Must pass an existing path!")
                return .child(index: 0, subpath: .target)
            }
            /// Children frames must all be contained by parent frame.
            let childrenInParent = children.allSatisfy({ parentRect.contains($0.origin) })
            assert(childrenInParent, "Invalid state!")
        }
        
        let nonOverlapping = children.allSatisfy { rect in
            children.allSatisfy { ($0 == rect) || ($0.contains(rect.origin) == false) }
        }
        assert(nonOverlapping, "Invalid state!")
        
        /// If contained, split by half height.
        if let idx = children.firstIndex(where: { $0.contains(point) }) {
            let yDiff = point.y - children[idx].minY
            if yDiff < children[idx].height / 2 {
                return parent.appending(.child(index: idx, subpath: .target))
            } else {
                return parent.appending(.child(index: idx + 1, subpath: .target))
            }
        } else {
            let precedingCount = children.filter({ $0.maxY < point.y }).count
            return parent.appending(.child(index: precedingCount, subpath: .target))
        }
    }
    
    /// Guaranteed to find a valid insertion path, close to the given point.
    fileprivate func closestInsertionPath(to point: CGPoint) -> ModelPath {
        
        /// Step 1: find the lowest (tree-wise) node on the tree that contains this point.
        let path = cardLocations
            .filter { $0.value.contains(point) }
            /// Assumption: lower nodes (contained by super-node) are necessarily visually shorter.
            .sorted(by: { $0.value.height < $1.value.height })
            .first(where: { params[$0.key].proxy.hasComponents})
        
        return findPath(parent: path?.key ?? .target, point: point)
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

