//
//  SandClient.Local.swift
//  Nea
//
//  Created by Ritesh Pakala on 3/22/25.
//

import MLX
import MLXLLM
import MLXLMCommon
import MLXRandom
import Metal
import SwiftUI
import Tokenizers
import Granite
import Foundation
import SandKit
import Combine

extension SandClient {
    func load() async throws -> ModelContainer {
        switch loadState {
        case .idle:
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 100 * 1024 * 1024)
            
            let modelContainer = try await LLMModelFactory.shared.loadContainer(
                configuration: modelConfiguration
            ) {
                [modelConfiguration] progress in
                Task { @MainActor in
                    self.modelInfo =
                    "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                }
            }
            let numParams = await modelContainer.perform { context in
                context.model.numParameters()
            }
            
            self.modelInfo =
            "Loaded \(modelConfiguration.id).  Weights: \(numParams / (1024*1024))M"
            loadState = .loaded(modelContainer)
            
            print("[SandClient] Loaded model container.")
            
            return modelContainer
            
        case .loaded(let modelContainer):
            print("[SandClient] Model container already loaded.")
            return modelContainer
        }
    }
    
    func askLocal<E: EventExecutable>(
        _ prompt: String,
        withSystemPrompt systemPrompt: String? = nil,
        withConfig config: PromptConfig,
        stream: Bool = true,
        event: E
    ) {
        print("[SandClient] Asking Locally")
        self.currentTask?.task = Task {
            
            var output = ""
            
            do {
                let modelContainer = try await load()
                print("[SandClient] Performing inference")
                // each time you generate you will get something new
                MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))
                
                let generateParameters = GenerateParameters(temperature: config.temperature?.asFloat ?? 0.5, topP: config.topP?.asFloat ?? 1.0)
                
                let sanitizedPrompt: String
                
                if let systemPrompt {
                    sanitizedPrompt = "<system>\(systemPrompt)</system>\n\(prompt)"
                } else {
                    sanitizedPrompt = prompt
                }
                
                let result = try await modelContainer.perform { context in
                    let input = try await context.processor.prepare(input: .init(prompt: sanitizedPrompt))
                    
                    var replyDebouncerInit: CGFloat = CFAbsoluteTimeGetCurrent()
                    
                    return try MLXLMCommon.generate(
                        input: input, parameters: generateParameters, context: context
                    ) { tokens in
                        // update the output -- this will make the view show the text as it generates
                        if tokens.count % displayEveryNTokens == 0 {
                            let text = context.tokenizer.decode(tokens: tokens)
                            
                            if let result = Postprocessor.sanitize(text) {
                                output = result
                                // Output
                                if CFAbsoluteTimeGetCurrent() - replyDebouncerInit >= 0.24 {
                                    replyDebouncerInit = CFAbsoluteTimeGetCurrent()
                                    event.send(Response(data: result, isComplete: false, isStream: false))
                                }
                            }
                        }
                        
                        if tokens.count >= maxTokens {
                            return .stop
                        } else {
                            return .more
                        }
                    }
                }
                
                // update the text if needed, e.g. we haven't displayed because of displayEveryNTokens
                if result.output != output {
                    if let result = Postprocessor.sanitize(result.output) {
                        output = result
                        
                        event.send(Response(data: result, isComplete: true, isStream: false))
                    }
                }
                // self.stat = " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"
                
            } catch {
                print("[SandClient] Error: \(error)")
                output = "Failed: \(error)"
            }
            
        }
    }
}
