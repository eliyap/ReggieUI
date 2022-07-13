//
//  SelectionViewController.swift
//  
//
//  Created by Secret Asian Man Dev on 13/7/22.
//

import UIKit
import SwiftUI
import Combine

final internal class SelectionViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hostedView = SelectionView(openBuilder: presentBuilder)
        let host = UIHostingController(rootView: hostedView)
        addChild(host)
        view.addSubview(host.view)
        host.didMove(toParent: self)

        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func presentBuilder() -> Void {
        let vc = BuilderViewController()
        vc.setModalPresentationStyle(to: .fullScreen)
        present(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SelectionView: View {
    
    public let openBuilder: () -> Void
    
    var body: some View {
        Text("todo")
            .onTapGesture {
                openBuilder()
            }
    }
}
