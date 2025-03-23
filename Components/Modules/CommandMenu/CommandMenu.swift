//
//  CommandMenu.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/~/23.
//

import Granite

struct CommandMenu: GraniteComponent {
    @Command var center: Center
    
    @Relay var sand: SandService
    @Relay var prompts: PromptService
    @Relay var query: QueryService
    
    @SharedObject(SessionManager.id) var session: SessionManager
}
