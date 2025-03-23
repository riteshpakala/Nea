//
//  SandClient.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/9/23.
//

import Foundation
import SandKit
import Combine
import Granite
import GPT3_Tokenizer

class SandClient {
    static let shared: SandClient = .init()
    
    @SharedObject(SessionManager.id) var session: SessionManager
    
    let kit = SandKit()
    
    let gpt3Tokenizer = GPT3Tokenizer()
    
    internal var currentTask: SandTask? = nil
    internal var reqDebounceTimer: Timer? = nil
    internal var replyCompletedTimer: Timer? = nil
    
    @Published var isResponding: Bool = false
    
    func ask<E: EventExecutable>(_ prompt: String,
                                 withSystemPrompt systemPrompt: String? = nil,
                                 withConfig config: PromptConfig,
                                 stream: Bool = true,
                                 event: E) {
        print("[SandClient] prompt token count: \(prompt.components(separatedBy: " ").count)")
        
        guard prompt.isNotEmpty else { return }
        
        currentTask?.cancel()
        currentTask = .init()
        isResponding = true
        
        print("[SandClient] creating Debounce Timer")
        
        reqDebounceTimer?.invalidate()
        reqDebounceTimer = Timer.scheduledTimer(
            withTimeInterval: 0.8.randomBetween(1.2),
            repeats: false) { [weak self] timer in
                
                print("[SandClient] invalidating timer")
                
                timer.invalidate()
                
                print("[SandClient] creatingTask")
                
                if stream {
                    self?.updateCompletedTimer(event)
                }
                
                self?.askLocal(
                    prompt,
                    withSystemPrompt: systemPrompt,
                    withConfig: config,
                    stream: stream,
                    event: event
                )
            }
    }
    
    func updateCompletedTimer<E: EventExecutable>(_ event: E) {
        DispatchQueue.main.async { [weak self] in
            self?.replyCompletedTimer?.invalidate()
            self?.replyCompletedTimer = Timer.scheduledTimer(
                withTimeInterval: 2.4,
                repeats: false) { completedTimer in
                    
                    print("[SandClient] stream isComplete")
                    
                    completedTimer.invalidate()
                    DispatchQueue.main.async { [weak self] in
                        self?.isResponding = false
                    }
                    event.send(Response(data: nil, isComplete: true, isStream: true))
                }
        }
    }
    
    func reset() {
        print("[SandClient] resetting")
        self.currentTask?.cancel()
        self.reqDebounceTimer?.invalidate()
        self.replyCompletedTimer?.invalidate()
        self.isResponding = false
    }
    
    struct Response: GranitePayload {
        var data: String?
        var isComplete: Bool
        var isStream: Bool
        var isRestoring: Bool = false
    }
}
