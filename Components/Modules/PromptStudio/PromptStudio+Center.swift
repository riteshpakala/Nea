//
//  PromptStudio+Center.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SwiftUI

extension PromptStudio {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var intent: PromptStudio.Intent = .collection
        }
        
        @Store public var state: State
    }
    
    enum Intent: GraniteModel {
        case create
        case edit(CustomPrompt)
        case collection
    }
}
