//
//  BuilderView.swift
//  ReggieUI
//
//  Created by Secret Asian Man Dev on 13/7/22.
//

import SwiftUI

struct BuilderView: View {
    
    public var sheetInsetConduit: SheetInsetConduit
    public var params: _RegexModel
    public let modalConduit: ModalConduit
    
    public let closeView: () -> Void
    
    var body: some View {
        VStack(spacing: .zero) {
            BuilderTitleView(closeView: closeView)
                .background {
                    Color(uiColor: .systemBackground)
                        .edgesIgnoringSafeArea(.top)
                }
            Divider()
            RegexView(sheetInsetConduit: sheetInsetConduit, params: params, modalConduit: modalConduit)
        }
    }
}

struct BuilderTitleView: View {
    
    public static let padding: CGFloat = 12
    public let closeView: () -> Void
    
    var body: some View {
        HStack {
            TitleCloseButtom(closeView: closeView)
            Text("My Cool Regex")
            Spacer()
        }
            .padding(Self.padding)
    }
}

struct TitleCloseButtom: View {
    
    public let closeView: () -> Void
    
    
    var body: some View {
        Button(action: closeView, label: {
            Image(systemName: "chevron.left")
        })
    }
}
