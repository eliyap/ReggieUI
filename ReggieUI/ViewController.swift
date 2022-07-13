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
        
        let vc = SelectionViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = self.view.frame
        vc.didMove(toParent: self)
    }
}

final internal class SelectionViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = BuilderViewController()
        vc.setModalPresentationStyle(to: .fullScreen)
        present(vc, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
