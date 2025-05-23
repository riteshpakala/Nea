import Granite
import SandKit
import Foundation
import SwiftUI

extension QueryService {
    struct Restore: GraniteReducer {
        typealias Center = QueryService.Center
        
        struct Meta: GranitePayload {
            let value: String
        }
        
        @Payload var meta: Meta?
        
        func reduce(state: inout Center.State) {
            guard let meta = self.meta else { return }
            SandClientTokenizerManager.shared.pause = true
            state.value = meta.value
            SandClientTokenizerManager.shared.pause = false
        }
    }
}
