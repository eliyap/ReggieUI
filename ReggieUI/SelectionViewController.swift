//
//  SelectionViewController.swift
//  
//
//  Created by Secret Asian Man Dev on 13/7/22.
//

import UIKit
import SwiftUI
import Combine
import RealmSwift

final internal class SelectionViewController: UIViewController {
    
    private let conduit: Conduit = .init()
    private var observers: Set<AnyCancellable> = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        conduit.pipeline
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.presentBuilder()
            }
            .store(in: &observers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hostedView = SelectionView()
            .environmentObject(conduit)
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
    
    private func presentBuilder() -> Void {
        let vc = BuilderViewController()
        vc.setModalPresentationStyle(to: .fullScreen)
        present(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        for observer in observers {
            observer.cancel()
        }
    }
}

extension SelectionViewController {
    final class Conduit: ObservableObject {
        public let pipeline: PassthroughSubject<Void, Never> = .init()
    }
}

final internal class ErrorConduit: ObservableObject {
    public let errorPipeline: CurrentValueSubject<SelectionError?, Never> = .init(nil)
}

enum SelectionError: LocalizedError {
    case realmDBError(RealmDBError)
    
    var errorDescription: String? {
        switch self {
        case .realmDBError(let error):
            return error.errorDescription
        }
    }
}

struct SelectionView: View {
    
    private var realm: Realm? = nil
    
    @State private var isShowingError: Bool = false
    private let errorConduit: ErrorConduit = .init()
    
    init() {
        self.realm = try? Realm()
    }
    
    var body: some View {
        ZStack {
            ErrorView
                .onAppear(perform: tryOpenRealm)
            if realm != nil {
                SelectionListView()
                    .environmentObject(errorConduit)
            }
        }
    }
    
    private func tryOpenRealm() -> Void {
        do {
            let _ = try Realm()
        } catch {
            errorConduit.errorPipeline.send(.realmDBError(.couldNotOpen))
        }
    }
    
    private var ErrorView: some View {
        /// Placeholder view against which to project errors.
        Color.clear
            .alert(isPresented: $isShowingError, error: errorConduit.errorPipeline.value, actions: { _ in
                Button(action: { isShowingError = false }, label: {
                    Text("Ok")
                })
            }, message: { error in
                Text("⚠️\nPlease contact the developer")
            })
            .onReceive(errorConduit.errorPipeline) { error in
                if error != nil {
                    isShowingError = true
                }
            }
    }
}

struct SelectionListView: View {
    
    @ObservedResults(RealmRegexModel.self) private var regexModels
    @EnvironmentObject private var conduit: SelectionViewController.Conduit
    
    var body: some View {
        VStack(spacing: .zero) {
            SelectionTitleView()
            Divider()
            LazyVStack {
                ForEach(regexModels) { regexModel in
                    Text(regexModel.name)
                        .onTapGesture {
                            conduit.pipeline.send(Void())
                        }
                }
            }
            Spacer()
        }
            .background {
                Color(uiColor: .secondarySystemBackground)
                    .edgesIgnoringSafeArea(.bottom)
            }
    }
}

struct SelectionTitleView: View {
    var body: some View {
        HStack {
            Text("Regexes")
                
            Spacer()
            NewRegexButton()
        }
            .padding(BuilderTitleView.padding)
            .background {
                Color(uiColor: .systemBackground)
                    .edgesIgnoringSafeArea(.top)
            }
    }
}

struct NewRegexButton: View {
    
    @EnvironmentObject private var errorConduit: ErrorConduit
    @EnvironmentObject private var conduit: SelectionViewController.Conduit
    
    var body: some View {
        Button(action: createRegex, label: {
            Image(systemName: "plus")
        })
    }
    
    private func createRegex() -> Void {
        guard let realm = try? Realm() else {
            errorConduit.errorPipeline.send(.realmDBError(.couldNotOpen))
            return
        }
        guard let newRegex = try? RealmRegexModel.createNew() else {
            errorConduit.errorPipeline.send(.realmDBError(.createNewFailed))
            return
        }
        do {
            try realm.writeWithToken { token in
                realm.add(newRegex, update: .error)
            }
        } catch {
            errorConduit.errorPipeline.send(.realmDBError(.writeFailed))
            return
        }

        conduit.pipeline.send(Void())
    }
}
