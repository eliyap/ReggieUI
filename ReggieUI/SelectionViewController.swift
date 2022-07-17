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
    private let errorConduit: ErrorConduit = .init()
    private var observers: Set<AnyCancellable> = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        conduit.pipeline
            .sink { [weak self] id in
                guard let self = self else { return }
                self.presentBuilder(id: id)
            }
            .store(in: &observers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let hostedView = SelectionView()
            .environmentObject(conduit)
            .environmentObject(errorConduit)
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
    
    private func presentBuilder(id: RealmRegexModel.ID) -> Void {
        switch regexIdToModel(id: id) {
        case .failure(let error):
            errorConduit.errorPipeline.send(.realmDBError(error))
        case .success((let regexID, let model)):
            let vc: BuilderViewController = .init(regexID: regexID, model: model, errorConduit: errorConduit)
            vc.setModalPresentationStyle(to: .fullScreen)
            present(vc, animated: true)
        }
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
        public let pipeline: PassthroughSubject<RealmRegexModel.ID, Never> = .init()
    }
}

final internal class ErrorConduit: ObservableObject {
    public let errorPipeline: CurrentValueSubject<SelectionError?, Never> = .init(nil)
}

enum SelectionError: LocalizedError {
    case realmDBError(RealmDBError)
    case spurious(SpuriousError)
    
    var errorDescription: String? {
        switch self {
        case .realmDBError(let error):
            return error.errorDescription
        case .spurious(let error):
            return error.errorDescription
        }
    }
}

struct SelectionView: View {
    
    @State private var didOpenRealm = false
    @State private var isShowingError: Bool = false
    @EnvironmentObject private var errorConduit: ErrorConduit
    
    var body: some View {
        ZStack {
            ErrorView
                .onAppear(perform: tryOpenRealm)
            if didOpenRealm {
                SelectionListView()
            }
        }
    }
    
    private func tryOpenRealm() -> Void {
        /// A no-op function that does nothing with the passed realm.
        let realmNoOp: (Realm) -> Result<Void, RealmDBError> = { _ in
            return .success(Void())
        }
        
        /// Just want to check if realm is open-able.
        switch accessRealm(operation: realmNoOp) {
        case .success:
            didOpenRealm = true
        case .failure(let error):
            errorConduit.errorPipeline.send(.realmDBError(error))
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
    
    @ObservedResults(RealmRegexModel.self, configuration: getOptionalConfiguration())
    private var regexModels
    
    @EnvironmentObject private var conduit: SelectionViewController.Conduit
    
    var body: some View {
        VStack(spacing: .zero) {
            SelectionTitleView()
            Divider()
            LazyVStack {
                ForEach(regexModels) { regexModel in
                    /// - Note: since reading / init happens on the same (main) thread, this should be safe
                    RegexListItem(name: regexModel.name, id: regexModel.id)
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

struct RegexListItem: View {
    
    @EnvironmentObject private var conduit: SelectionViewController.Conduit
    
    public let name: String
    public let id: RealmRegexModel.ID
    
    var body: some View {
        Text(name)
            .onTapGesture {
                conduit.pipeline.send(id)
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
        func realmOp(realm: Realm) -> Result<RealmRegexModel.ID, RealmDBError> {
            guard let newRegex = try? RealmRegexModel.createNew() else {
                return .failure(.createNewObjectFailed)
            }
            do {
                try realm.writeWithToken { token in
                    realm.add(newRegex, update: .error)
                }
            } catch {
                return .failure(.writeFailed)
            }

            /// - Note: same function, same thread, therefore this is safe.
            return .success(newRegex.id)
        }
        
        switch accessRealm(operation: realmOp) {
        case .failure(let error):
            errorConduit.errorPipeline.send(.realmDBError(error))
            
        case .success(let id):
            conduit.pipeline.send(id)
        }
    }
}
