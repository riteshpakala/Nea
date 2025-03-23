//
//  SandClient.Local.swift
//  Nea
//
//  Created by Ritesh Pakala on 3/22/25.
//

import Metal
import SwiftUI
import Granite
import Foundation
import SandKit
import Combine

extension SandClient {
    func askLocal<E: EventExecutable>(
        _ prompt: String,
        withSystemPrompt systemPrompt: String? = nil,
        withConfig config: PromptConfig,
        stream: Bool = true,
        event: E
    ) {
        print("[SandClient] Asking Locally")
        self.currentTask?.task = Task {
            do {
                var replyDebouncerInit: CGFloat = CFAbsoluteTimeGetCurrent()
                
                try await kit
                    .generate(
                        prompt: prompt,
                        systemPrompt: systemPrompt,
                        config: config,
                        stream: stream
                    ) {
                        output,
                        isComplete in
                        
                        if CFAbsoluteTimeGetCurrent() - replyDebouncerInit >= 0.24 {
                            replyDebouncerInit = CFAbsoluteTimeGetCurrent()
                            event
                                .send(
                                    Response(
                                        data: output,
                                        isComplete: isComplete,
                                        isStream: stream
                                    )
                                )
                        }
                }
            } catch {
                print("[SandClient] Error: \(error)")
            }
        }
    }
}
