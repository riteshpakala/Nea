//
//  Account.Logout.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/5/23.
//

import Granite
import AuthenticationServices

extension AccountService {
    struct Logout: GraniteReducer {
        typealias Center = AccountService.Center
        
        func reduce(state: inout Center.State) {
            
            AccountManager.logout()
        }
    }
}
