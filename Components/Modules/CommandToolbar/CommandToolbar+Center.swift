//
//  CommandToolbar+Center.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SwiftUI

extension CommandToolbar {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var scSelected: String = ""
            var toggleDropdown: Bool = false
            var showFileExtAlert: Bool = false
            
            var editorProperties: FileTextEditorView.Properties? = nil
        }
        
        @Store public var state: State
    }
}
