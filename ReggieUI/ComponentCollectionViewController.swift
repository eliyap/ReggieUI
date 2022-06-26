//
//  ComponentCollectionViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import Foundation
import UIKit
import SwiftUI

final internal class ComponentCollectionViewController: UICollectionViewController {
    
    public typealias DataSource = UICollectionViewDiffableDataSource<ComponentSection, String>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<ComponentSection, String>
    private var dataSource: DataSource! = nil
    
    public typealias Cell = ComponentCell
    
    init() {
        let layout = createListLayout()
        super.init(collectionViewLayout: layout)
        /// Defuse implicitly unwrapped nil.
        dataSource = .init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration {
                Text("Hello World")
            }
            return cell
        })
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        
        // DEBUG
        collectionView.backgroundColor = .purple
        
        // PLACEHOLDER
        var snapshot = Snapshot()
        snapshot.appendSections([.complex])
        snapshot.appendItems([
            "Potato",
            "Tomato",
        ], toSection: .complex)
        dataSource.apply(snapshot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
