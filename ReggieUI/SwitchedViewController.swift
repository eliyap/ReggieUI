//
//  SwitchedViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 4/7/22.
//

import UIKit

final internal class SwitchedViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let cvc = ComponentCollectionViewController()
        addChild(cvc)
        view.addSubview(cvc.view)
        cvc.didMove(toParent: self)
        
        cvc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cvc.view.topAnchor.constraint(equalTo: view.topAnchor),
            cvc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cvc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cvc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
