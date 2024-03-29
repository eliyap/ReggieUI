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
    private let regexID: RealmRegexModel.ID
    private let model: ComponentsModel
    
    private var errorConduit: ErrorConduit
          
    init(
        regexID: RealmRegexModel.ID,
        model: ComponentsModel,
        errorConduit: ErrorConduit
    ) {
        self.regexID = regexID
        self.model = model
        self.errorConduit = errorConduit
        self.picker = .init(sheetInsetConduit: sheetInsetConduit, model: model)
        super.init(nibName: nil, bundle: nil)
        
        addHostedView()
        
        modalConduit.hostIsPresenting
            .sink(receiveValue: duckPresentation)
            .store(in: &observers)
        
        model.$components
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] components in
                guard let self = self else { return }
                
                switch save(components: components, to: regexID) {
                case .failure(let error):
                    self.dismiss(animated: false)
                    self.errorConduit.errorPipeline.send(.realmDBError(error))
                case .success:
                    break
                }
            }
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
