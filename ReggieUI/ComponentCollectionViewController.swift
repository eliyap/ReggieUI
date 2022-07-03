//
//  ComponentCollectionViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import Foundation
import UIKit
import SwiftUI
import RegexModel

final internal class ComponentCollectionViewController: UICollectionViewController {
    
    public typealias DataSource = UICollectionViewDiffableDataSource<ComponentModel.Section, ComponentModel.Proxy>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<ComponentModel.Section, ComponentModel.Proxy>
    private var dataSource: DataSource! = nil
    
    public typealias Cell = ComponentCell
    
    init() {
        let layout = createListLayout()
        super.init(collectionViewLayout: layout)
        /// Defuse implicitly unwrapped nil.
        dataSource = .init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)
            
            guard let proxy = Self.proxy(at: indexPath) else {
                assert(false, "Could not get resolve proxy at path \(indexPath)")
                return cell
            }
            
            cell.contentConfiguration = UIHostingConfiguration {
                Text(proxy.displayTitle)
            }
            return cell
        })
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.dragDelegate = self
        
        // DEBUG
        collectionView.backgroundColor = .purple
        
        // PLACEHOLDER
        var snapshot = Snapshot()
        snapshot.appendSections(ComponentModel.Section.allCases)
        for section in ComponentModel.Section.allCases {
            snapshot.appendItems(section.proxyItems, toSection: section)
        }
        dataSource.apply(snapshot)
    }
    
    private static func proxy(at indexPath: IndexPath) -> ComponentModel.Proxy? {
        /// Get section and row.
        guard let section = ComponentModel.Section(rawValue: indexPath.section) else {
            assert(false, "Could not initialize section from section number \(indexPath.section)")
            return nil
        }
        guard section.proxyItems.indices ~= indexPath.row else {
            assert(false, "Section does not have item at row \(indexPath.row)")
            return nil
        }
        return section.proxyItems[indexPath.row]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComponentCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let proxy = Self.proxy(at: indexPath) else {
            assert(false, "Could not get resolve proxy at path \(indexPath)")
            return []
        }
        
        let itemProvider = NSItemProvider(object: proxy.rawValue as NSString)
        return [UIDragItem(itemProvider: itemProvider)]
    }
}

final internal class ComponentCell: UICollectionViewCell {
    
    public static let identifier: String = "ComponentCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        // DEBUG
        layer.borderWidth = 4
        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal enum ComponentSection: Int {
    /// Placeholders, obviously.
    case simple
    case complex
}
