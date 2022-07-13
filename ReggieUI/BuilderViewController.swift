//
//  BuilderViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 12/7/22.
//

import UIKit
import SwiftUI
import Combine

final internal class BuilderViewController: UIViewController {
    
    private let sheetInsetConduit: SheetInsetConduit = .init()
    private let modalConduit: ModalConduit = .init()
    private let picker: PickerViewController
    private var observers: Set<AnyCancellable> = []
    private let model: _RegexModel = .init(id: .init(), components: _RegexModel.example)
    
    init() {
        picker = .init(sheetInsetConduit: sheetInsetConduit, model: model)
        super.init(nibName: nil, bundle: nil)
        
        let hostedView = RegexView(
            sheetInsetConduit: sheetInsetConduit,
            params: model,
            modalConduit: modalConduit
        )
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
        
        modalConduit.hostIsPresenting
            .sink { [weak self] isPresenting in
                guard let self = self else { return }
                if isPresenting {
                    self.picker.dismiss(animated: false)
                } else {
                    self.picker.configureSheet()
                    self.present(self.picker, animated: true)
                }
            }
            .store(in: &observers)
        
        // DEBUG
        #if DEBUG
//        view.layer.borderColor = UIColor.red.cgColor
//        view.layer.borderWidth = 2
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Configure and present sheet.
        picker.configureSheet()
        present(picker, animated: true)
    }
    
    /// Explicitly allow external configuration.
    public func setModalPresentationStyle(to style: UIModalPresentationStyle) -> Void {
        self.modalPresentationStyle = style
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        for observer in observers {
            observer.cancel()
        }
    }
}
