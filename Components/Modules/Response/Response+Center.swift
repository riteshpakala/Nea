//
//  Response+Center.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SwiftUI

extension Response {
    struct Center: GraniteCenter {
        struct State: GraniteState {
            var response: String = "Hello!"
        }
        
        @Store public var state: State
    }
}
