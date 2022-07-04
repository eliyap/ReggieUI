//
//  TestsViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 4/7/22.
//

import UIKit
import RegexModel
import SwiftUI

// PLACEHOLDER
internal enum TestsSection: Int, Hashable {
    case main
    
    var items: [TestModel] {
        switch self {
        case .main:
            return [.example]
        }
    }
}
final internal class TestsViewController: UICollectionViewController {
    
    public typealias DataSource = UICollectionViewDiffableDataSource<TestsSection, TestModel>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<TestsSection, TestModel>
    private var dataSource: DataSource! = nil
    
    public typealias Cell = ComponentCell
    
    init(model: _RegexModel) {
        let layout = createListLayout()
        super.init(collectionViewLayout: layout)
        /// Defuse implicitly unwrapped nil.
        dataSource = .init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)
            
            cell.contentConfiguration = UIHostingConfiguration {
                Text("PLACEHOLDER")
            }
            return cell
        })
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        
        // DEBUG
        collectionView.backgroundColor = .secondarySystemBackground
        
        // PLACEHOLDER
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.example], toSection: .main)
        dataSource.apply(snapshot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final internal class _TestsCell: UICollectionViewCell {
    
    public static let identifier: String = "ComponentCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        // DEBUG
//        self.backgroundColor = .blue
//        layer.borderWidth = 4
//        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
