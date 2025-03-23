//
//  SandClient.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/9/23.
//

import MLX
import MLXLLM
import MLXLMCommon
import Foundation
import SandKit
import Combine
import Granite
import GPT3_Tokenizer

class SandClient {
    static let shared: SandClient = .init()
    
    @SharedObject(SessionManager.id) var session: SessionManager
    
    // Local
    /// This controls which model loads. `phi3_5_4bit` is one of the smaller ones, so this will fit on
    /// more devices.
    var modelInfo = ""
    let modelConfiguration = LLMModels.DeepSeek.Local.r1_32_distill_qwen_4bit

    /// parameters controlling the output
    let maxTokens = 1200

    /// update the display every N tokens -- 4 looks like it updates continuously
    /// and is low overhead.  observed ~15% reduction in tokens/s when updating
    /// on every token
    let displayEveryNTokens = 4

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState = LoadState.idle
    
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
