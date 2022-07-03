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
            
            /// Get section and row.
            guard let section = ComponentModel.Section(rawValue: indexPath.section) else {
                assert(false, "Could not initialize section from section number \(indexPath.section)")
                return cell
            }
            guard section.proxyItems.indices ~= indexPath.row else {
                assert(false, "Section does not have item at row \(indexPath.row)")
                return cell
            }
            let proxy = section.proxyItems[indexPath.row]
            
            cell.contentConfiguration = UIHostingConfiguration {
                Text("Hello World")
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComponentCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [
            UIDragItem(itemProvider: NSItemProvider(object: "" as NSString)),
        ]
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
