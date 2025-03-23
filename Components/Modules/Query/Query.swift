//
//  Query.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite
import SandKit

struct Query: GraniteComponent {
    @Command var center: Center
    
    @Relay var environment: EnvironmentService
    @Relay var account: AccountService
    @Relay var sand: SandService
    @Relay var prompts: PromptService
    
    @SharedObject(SessionManager.id) var session: SessionManager
}
