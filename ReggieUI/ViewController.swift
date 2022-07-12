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
