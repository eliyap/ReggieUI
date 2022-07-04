//
//  PickerViewController.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 26/6/22.
//

import UIKit
import SwiftUI

final internal class PickerViewController: UIViewController {
    
    private let sheetInsetConduit: SheetInsetConduit
    
    init(sheetInsetConduit: SheetInsetConduit) {
        self.sheetInsetConduit = sheetInsetConduit
        super.init(nibName: nil, bundle: nil)
        
        #warning("todo: fix padding and background")
        view.backgroundColor = .systemBackground
        
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
        
        addSearchBar(to: stackView)

        let cvc = ComponentCollectionViewController()
        addChild(cvc)
        cvc.didMove(toParent: self)
        
        stackView.addArrangedSubview(cvc.view)
    }
    
    private func addSearchBar(to stackView: UIStackView) -> Void {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = true
        searchBar.placeholder = "Search for Regular Expression parts"
        
        /// Experimentally determined.
        /// Goal is to have equal spacing between the top of the sheet and the grab handle, and the bottom of the grab handle and top of the saerch bar.
        let barInsets: CGFloat = 6
        let barContainer = UIView()
        barContainer.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: barContainer.topAnchor, constant: barInsets),
            searchBar.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor, constant: -barInsets),
            searchBar.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor, constant: barInsets),
            searchBar.trailingAnchor.constraint(equalTo: barContainer.trailingAnchor, constant: -barInsets),
        ])
        stackView.addArrangedSubview(barContainer)
    }
    
    public func configureSheet() {
        if let sheet = self.sheetPresentationController {
            /// Prevents sheet from being dismissed.
            /// https://stackoverflow.com/questions/56459329/disable-the-interactive-dismissal-of-presented-view-controller
            self.isModalInPresentation = true
            
            sheet.detents = [
                /// - Note: disabled, because adding this would require custom code to "duck" the sheet when dragging out out large
                ///         detent, similar to Shortcuts.
                //.large(),
                
                .medium(),
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
        withAnimation(.default) {
            sheetInsetConduit.sheetObscuringHeight = view.frame.height
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UISheetPresentationController.Detent.Identifier {
    /// Should only show the search bar.
    static let small = UISheetPresentationController.Detent.Identifier("small")
}

