//
//  VaultProducts.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/12/23.
//

import Foundation
import VaultKit

struct VaultProducts {
    enum Renewable: String, VaultProductIterable {
        case yearly = "..."
        case monthly = "...."
        case weekly = "....."
        
        var kind: VaultProductKind {
            .renewable
        }
    }
}
