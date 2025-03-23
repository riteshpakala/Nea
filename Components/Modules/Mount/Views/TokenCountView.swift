//
//  TokenCountView.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/22/23.
//

import Foundation
import SwiftUI
import Granite
import GPT3_Tokenizer
import SandKit

struct StatView: View {
    @Environment(DeviceStat.self) private var deviceStat: DeviceStat
    
    @Relay var sand: SandService
    @Relay var query: QueryService
    @Relay var prompts: PromptService
    
    @State var tokenCount: Int = 0
    
    let tokenizer: GPT3Tokenizer = .init()
    var maxTokenCount: Int {
        prompts.maxTokenCount(sand.state.commandSet)
    }
    
    var body: some View {
        VStack {
            if tokenCount == 0 {
                EmptyView()
            } else {
                HStack(spacing: Brand.Padding.medium8) {
                    Spacer()
                    
                    Label(
                        "\(deviceStat.deviceMemoryUsage)",
                        systemImage: "info.circle.fill"
                    )
                    .labelStyle(.titleAndIcon)
                    .padding(.horizontal)
                    .help(
                        Text(deviceStat.memoryDetailedInfo)
                    )
                    
                    Text("Token count: ")
                        .font(Fonts.live(.caption, .bold))
                        .foregroundColor(.foreground) + Text("\(tokenCount)/\(maxTokenCount)")
                        .font(Fonts.live(.caption, .bold))
                        .foregroundColor((tokenCount <= maxTokenCount ? Brand.Colors.green : Brand.Colors.red).opacity(0.55))
                    
                }
            }
            
            Spacer()
        }
        .allowsHitTesting(false)
        .onChange(of: query.center.$state.binding.value.wrappedValue) { newValue in
            
            DispatchQueue.global(qos: .utility).async {
                let newCount = tokenizer.encoder.enconde(text: newValue).count
                DispatchQueue.main.async {
                    tokenCount = newCount
                }
            }
        }
    }
}
