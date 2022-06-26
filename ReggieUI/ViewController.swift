//
//  ViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import UIKit

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
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let picker = PickerViewController()
        picker.configureSheet()
        present(picker, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
