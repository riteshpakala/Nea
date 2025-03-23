//
//  ShortcutBar+Center.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SwiftUI

extension ShortcutBar {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var lastCopiedText: String = ""
        }
        
        @Store public var state: State
    }
}
