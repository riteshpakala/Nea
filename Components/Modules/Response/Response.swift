//
//  Response.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SandKit

struct Response: GraniteComponent {
    @Command var center: Center
    
    @Relay var environment: EnvironmentService
    @Relay var sand: SandService
    @Relay var config: ConfigService
    @Relay var prompts: PromptService
    
    var prompt: (any BasicPrompt)? {
        prompts.prompt(sand.state.commandSet)
    }
}
