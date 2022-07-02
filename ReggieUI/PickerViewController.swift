//
//  PickerViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import UIKit

final internal class PickerViewController: UIViewController {
    
    private let sheetInsetConduit: SheetInsetConduit
    
    init(sheetInsetConduit: SheetInsetConduit) {
        self.sheetInsetConduit = sheetInsetConduit
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .red
        
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let searchBar = UISearchBar()
        stackView.addArrangedSubview(searchBar)

        let cvc = ComponentCollectionViewController()
        addChild(cvc)
        cvc.didMove(toParent: self)
        
        stackView.addArrangedSubview(cvc.view)
    }
    
    public func configureSheet() {
        if let sheet = self.sheetPresentationController {
            /// Prevents sheet from being dismissed.
            /// https://stackoverflow.com/questions/56459329/disable-the-interactive-dismissal-of-presented-view-controller
            self.isModalInPresentation = true
            
            sheet.detents = [
                .medium(),
                .large(),
                .custom(identifier: .small, resolver: { context in
                    #warning("TODO: adapt to dynamic type!")
                    return 100
                })
            ]
            
            /// Allow scrolling through at `.medium()` sheet height.
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            
            /// Always show grabber, since scrolling doesn't resize.
            sheet.prefersGrabberVisible = true
            
            /// Don't dim the existing UI at `.medium()` height or smaller.
            sheet.largestUndimmedDetentIdentifier = .medium
            
            /// Don't show full-screen modal in phone landscape.
            /// - Note: you will get a full width sheet, but can change that with `widthFollowsPreferredContentSizeWhenEdgeAttached`.
            sheet.prefersEdgeAttachedInCompactHeight = true
            
            sheet.preferredCornerRadius = 15
        } else {
            Swift.debugPrint("Sheet controller not available!")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sheetInsetConduit.sheetObscuringHeight = view.frame.height
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UISheetPresentationController.Detent.Identifier {
    /// Should only show the search bar.
    static let small = UISheetPresentationController.Detent.Identifier("small")
}

