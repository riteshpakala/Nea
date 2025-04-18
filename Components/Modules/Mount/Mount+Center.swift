//
//  Mount+Center.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SwiftUI

extension Mount {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var query: String = ""
            var isEditing: Bool = false
            
            var response: String = ""
            
            var queryContentHeight: CGFloat = 48
            
        }
        
        @Store public var state: State
    }
}
