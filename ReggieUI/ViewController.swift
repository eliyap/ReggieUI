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
    private let modalConduit: ModalConduit = .init()
    private let picker: PickerViewController
    private var observers: Set<AnyCancellable> = []
    private let model: _RegexModel = .init(components: _RegexModel.example)
    
    init() {
        picker = .init(sheetInsetConduit: sheetInsetConduit, model: model)
        super.init(nibName: nil, bundle: nil)
        
        let hostedView = RegexView(sheetInsetConduit: sheetInsetConduit, modalConduit: modalConduit)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Configure and present sheet.
        picker.configureSheet()
        present(picker, animated: true)
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

/// App's `Combine` based nervous system for event passing.
final class SheetInsetConduit: ObservableObject {
    /// The amount of height that the sheet is obscuring of the view behind.
    @Published public var sheetObscuringHeight: CGFloat = .zero
}

/// Controls which View Controller is presenting a modal, to avoid conflicts.
/// - Note: `ObservableObject` conformance lets us inject this as an `@EnvironmentObject`,
///         but this should not have `@Published` properties to avoid heavy view updates!
internal final class ModalConduit: ObservableObject {
    /// Indicates when the SwiftUI `UIHostingController` starts / stops presenting a modal.
    public let hostIsPresenting: PassthroughSubject<Bool, Never> = .init()
}
