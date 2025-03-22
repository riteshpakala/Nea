//
//  SessionManager.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/13/23.
//

import Foundation
import Granite
import Combine
import VaultKit

class SessionManagerKit {
    @Published var isLoggedIn: Bool = false
    @Published var isSubscribed: Bool = false
    @Published var isPurchasing: Bool = false
    @Published var isCustomAPI: Bool = false
    
    public func isLoggedIn(_ state: Bool) {
        isLoggedIn = state
    }
    
    public func isSubscribed(_ state: Bool) {
        isSubscribed = state
    }
    
    public func isPurchasing(_ state: Bool) {
        isPurchasing = state
    }
    
    public func isCustomAPI(_ state: Bool) {
        isCustomAPI = state
    }
}

final class SessionManager: Equatable, SharableObject {
    static func == (lhs: SessionManager, rhs: SessionManager) -> Bool {
        lhs.kit.isLoggedIn == rhs.kit.isLoggedIn &&
        lhs.kit.isSubscribed == rhs.kit.isSubscribed &&
        lhs.kit.isCustomAPI == rhs.kit.isCustomAPI
    }
    
    public static var initialValue: SessionManager {
        .init()
    }
    
    public static var isDebug: Bool = true
    
    public static var id : String = "nyc.stoic.Nea.SessionManager"
    
    internal var cancellables = Set<AnyCancellable>()
    
    var isLocked: Bool {
        guard SessionManager.isDebug == false else {
            return false
        }
        
        guard kit.isLoggedIn else {
            return true
        }
        
        guard SessionManager.IS_API_ACCESS_ENABLED == false else {
            return kit.isCustomAPI == false
        }
        
        return kit.isSubscribed == false
    }
    
    var isLoggedIn: Bool {
        kit.isLoggedIn || SessionManager.isDebug
    }
    
    var isSubscribed: Bool {
        kit.isSubscribed || SessionManager.isDebug
    }
    
    var isFullAccess: Bool {
        VaultProducts.Renewable.allCases.filter { VaultManager.isPurchased($0) }.isEmpty == false || SessionManager.isDebug
    }
    
    var isPurchasing: Bool {
        kit.isPurchasing
    }
    
    static var IS_API_ACCESS_ENABLED: Bool {
        true
    }
    
    static var DISABLE_LOGIN: Bool {
        true || SessionManager.IS_API_ACCESS_ENABLED
    }
    
    let kit: SessionManagerKit
    
    init() {
        kit = .init()
        observe()
    }
    
    private func observe() {
        kit.$isLoggedIn
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        kit.$isSubscribed
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        kit.$isPurchasing
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    public func isLoggedIn(_ state: Bool) {
        kit.isLoggedIn = state
    }
    
    public func isSubscribed(_ state: Bool) {
        kit.isSubscribed = state
    }
    
    public func isCustomAPI(_ state: Bool) {
        kit.isCustomAPI = state
    }
    
    public func isPurchasing(_ state: Bool) {
        kit.isPurchasing = state
    }
    
    public func checkSubscription() {
        kit.isSubscribed = VaultManager.isSubscribed
    }
    
    public func sharableLoaded() {
        
    }
}
