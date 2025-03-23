//
//  GeneralConfigView.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/5/23.
//

import Foundation
import SwiftUI
import Granite
import ServiceManagement
import VaultKit

struct GeneralConfigView: View {
    @Environment(\.openURL) var openURL
    
    @Relay var config: ConfigService
    @Relay var account: AccountService
    
    @SharedObject(SessionManager.id) var session: SessionManager
    
    init() {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                HStack {
                    Text("Settings")
                        .font(Fonts.live(.title2, .bold))
                        .foregroundColor(.foreground)
                    
                    Spacer()
                }
                .padding(.bottom, 8)
                
                Text("Behavior")
                    .font(Fonts.live(.headline, .bold))
                    .foregroundColor(.foreground)
                
                HStack {
                    Toggle("Start on launch", isOn: config.center.$state.binding.launchAtLogin)
                    
                    Spacer()
                }
                
                HStack {
                    Toggle("Stream response", isOn: config.center.$state.binding.streamResponse)
                    
                    Spacer()
                }
                
//                Text("Engine Class")
//                    .font(Fonts.live(.headline, .bold))
//                    .foregroundColor(.foreground)
//                    .padding(.top, 8)
            }
            
            
//            Text("Accessibility")
//                .font(Fonts.live(.headline, .bold))
//                .foregroundColor(.foreground)
//
//            HStack {
//                Toggle("Visual guide", isOn: config.center.$state.binding.showVisualGuide)
//
//                Spacer()
//            }
//            .padding(.bottom, 8)
            TuningView(updateCustomConfigDirectly: true,
                       config: config.state.customPromptConfig)
            .padding(.top, 8)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
    }
    
    
}
