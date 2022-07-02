//
//  ViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let vc = BuilderViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = self.view.frame
        vc.didMove(toParent: self)
    }
}

final internal class BuilderViewController: UIViewController { 
    
    private let sheetInsetConduit: SheetInsetConduit = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let host = UIHostingController(rootView: RegexView(sheetInsetConduit: sheetInsetConduit))
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Create and present sheet.
        let picker = PickerViewController(sheetInsetConduit: sheetInsetConduit)
        picker.configureSheet()
        present(picker, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// App's `Combine` based nervous system for event passing.
final class SheetInsetConduit: ObservableObject {
    /// The amount of height that the sheet is obscuring of the view behind.
    @Published public var sheetObscuringHeight: CGFloat = .zero
}
