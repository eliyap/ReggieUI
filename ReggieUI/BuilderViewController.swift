//
//  BuilderViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 12/7/22.
//

import UIKit
import SwiftUI
import Combine
import RealmSwift

final internal class BuilderViewController: UIViewController {
    
    private let sheetInsetConduit: SheetInsetConduit = .init()
    private let modalConduit: ModalConduit = .init()
    private let picker: PickerViewController
    private var observers: Set<AnyCancellable> = []
    private let model: ComponentsModel = .init(components: ComponentsModel.example)
    
    private var errorConduit: ErrorConduit
    
    static func create(errorConduit: ErrorConduit, id: RealmRegexModel.ID) -> Result<BuilderViewController, SelectionError> {
        
        return .failure(.spurious(.problem))
        
//        let vc: BuilderViewController = .init(errorConduit: errorConduit)
//        return .success(vc)
    }
    
    private init(errorConduit: ErrorConduit) {
        self.errorConduit = errorConduit
        self.picker = .init(sheetInsetConduit: sheetInsetConduit, model: model)
        super.init(nibName: nil, bundle: nil)
        
        addHostedView()
        
        modalConduit.hostIsPresenting
            .sink(receiveValue: duckPresentation)
            .store(in: &observers)
        
        // DEBUG
        #if DEBUG
//        view.layer.borderColor = UIColor.red.cgColor
//        view.layer.borderWidth = 2
        #endif
    }
    
    private func addHostedView() -> Void {
        let hostedView = BuilderView(
            sheetInsetConduit: sheetInsetConduit,
            params: model,
            modalConduit: modalConduit,
            closeView: { [weak self] in
                guard let self = self else { return }
                self.picker.dismiss(animated: false)
                self.dismiss(animated: true)
            }
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
    }
    
    /// Coordinates presentation between SwiftUI and UIKit.
    /// UIKit's sheet controller gets angry if SwiftUI tries to present while it is also presenting,
    /// so we temporarily hide the sheet.
    private func duckPresentation(_ hostedViewIsPresenting: Bool) -> Void {
        if hostedViewIsPresenting {
            picker.dismiss(animated: false)
        } else {
            picker.configureSheet()
            present(self.picker, animated: true)
        }
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
