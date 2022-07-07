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
    
    public typealias Cell = _TestsCell
    
    init(model: _RegexModel) {
        let layout = createListLayout()
        super.init(collectionViewLayout: layout)
        /// Defuse implicitly unwrapped nil.
        dataSource = .init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)
            
            cell.contentConfiguration = UIHostingConfiguration {
                TestView(model: model, test: .example)
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

struct TestView: View {
    
    public var model: _RegexModel
    public let test: TestModel
    
    @State private var param_string: String = ""
    @State private var matches: [Substring]? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(test.name)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: runTest) {
                    Image(systemName: "play.fill")
                }
            }
            Text("String")
                .fontWeight(.medium)
            TextEditor(text: $param_string)
                .onAppear { param_string = test.string }
            if let matches {
                Text(matches.isEmpty ? "No Matches" : "Matches")
                    .fontWeight(.medium)
                ForEach(matches, id: \.self) { match in
                    Text("- \(String(match))")
                }
            }
        }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(uiColor: .systemBackground))
            }
            .padding(10)
    }
    
    func runTest() -> Void {
        withAnimation {
            #warning("Uncaught errors!")
            print(model.components)
            matches = try! test.test(against: model.components.regex())
        }
    }
}
