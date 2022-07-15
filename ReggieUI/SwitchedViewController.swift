//
//  SwitchedViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 4/7/22.
//

import UIKit

final internal class SwitchedViewController: UIViewController {
    
    public let componentsViewController = ComponentCollectionViewController()
    public let testsViewController: TestsViewController
    
    init(model: ComponentsModel) {
        self.testsViewController = .init(model: model)
        super.init(nibName: nil, bundle: nil)

        /// TestsViewController
        addChild(testsViewController)
        view.addSubview(testsViewController.view)
        testsViewController.didMove(toParent: self)

        testsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testsViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            testsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            testsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        /// Add second so it's above by default
        addChild(componentsViewController)
        view.addSubview(componentsViewController.view)
        componentsViewController.didMove(toParent: self)
        
        componentsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            componentsViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            componentsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            componentsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            componentsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    public func bringToFront(_ index: Int) -> Void {
        switch index {
        case 0:
            view.bringSubviewToFront(componentsViewController.view)
        case 1:
            view.bringSubviewToFront(testsViewController.view)
        default:
            assert(false, "Unknown selection!")
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
