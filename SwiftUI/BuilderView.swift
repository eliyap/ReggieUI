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
    
    var body: some View {
        RegexView(sheetInsetConduit: sheetInsetConduit, params: params, modalConduit: modalConduit)
    }
}
