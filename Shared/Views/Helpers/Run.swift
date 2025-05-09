//
//  Run.swift
//  * stoic
//
//  Created by Ritesh Pakala Rao on 1/7/21.
//

import Foundation
import SwiftUI

struct Run: View {
    let block: () -> Void

    var body: some View {
        DispatchQueue.main.async(execute: block)
        return AnyView(EmptyView())
    }
}
