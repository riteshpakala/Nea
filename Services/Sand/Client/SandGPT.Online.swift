//
//  SandGPT.Online.swift
//  Nea
//
//  Created by Ritesh Pakala on 3/22/25.
//

import Granite
import Foundation
import SandKit
import Combine

extension SandGPT {
    func askOnline<E: EventExecutable>(
        _ prompt: String,
        withSystemPrompt systemPrompt: String? = nil,
        withConfig config: PromptConfig,
        stream: Bool = true,
        event: E,
        _ engineClass: APITYPE = .local
    ) {
        print("[SandGPT Asking Online")
        self.currentTask?.task = Task {
            
            var reply: String = ""
            
            if stream && engineClass == .openai,
               let client = self.client {
                var replyDebouncerInit: CGFloat = CFAbsoluteTimeGetCurrent()
                for try await nextWord in try await client
                    .streamedAnswer.ask(prompt,
                                        withSystemPrompt: systemPrompt,
                                        withConfig: config) {
                    
                    SandGPT.shared.updateCompletedTimer(event)
                    
                    reply += nextWord
                    
                    //print("[SandGPT] streaming // nextWord: \(nextWord)")
                    
                    if CFAbsoluteTimeGetCurrent() - replyDebouncerInit >= 0.24 {
                        replyDebouncerInit = CFAbsoluteTimeGetCurrent()
                        event.send(Response(data: reply, isComplete: false, isStream: true))
                    }
                }
            } else {
                
                switch engineClass {
                case .openai:
                    reply = (try await self.client?.ask(prompt, withSystemPrompt: systemPrompt, withConfig: config)) ?? ""
                case .azure:
                    reply = (try await self.clientAzure?.ask(prompt, withSystemPrompt: systemPrompt, withConfig: config)) ?? ""
                default:
                    break
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.isResponding = false
                }
                
                event.send(Response(data: reply, isComplete: true, isStream: false))
            }
        }
    }
}
