//
//  LLMEvaluator.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 3/22/25.
//  Based on: https://github.com/ml-explore/mlx-swift-examples/blob/main/Applications/LLMEval/ContentView.swift

import MLX
import MLXLLM
import MLXLMCommon
import MLXRandom
import Metal
import SwiftUI
import Tokenizers

@Observable
@MainActor
class LLMEvaluator {

    var running = false

    var output = ""
    var modelInfo = ""
    var stat = ""

    /// This controls which model loads. `phi3_5_4bit` is one of the smaller ones, so this will fit on
    /// more devices.
    let modelConfiguration = LLMModels.DeepSeek.Local.r1_32_distill_qwen_4bit

    /// parameters controlling the output
    let generateParameters = GenerateParameters(temperature: 0.6)
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

    /// load and return the model -- can be called multiple times, subsequent calls will
    /// just return the loaded model
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
            return modelContainer

        case .loaded(let modelContainer):
            return modelContainer
        }
    }

    func generate(prompt: String) async {
        guard !running else { return }

        running = true
        self.output = ""

        do {
            let modelContainer = try await load()

            // each time you generate you will get something new
            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = try await modelContainer.perform { context in
                let input = try await context.processor.prepare(input: .init(prompt: prompt))
                return try MLXLMCommon.generate(
                    input: input, parameters: generateParameters, context: context
                ) { tokens in
                    // update the output -- this will make the view show the text as it generates
                    if tokens.count % displayEveryNTokens == 0 {
                        let text = context.tokenizer.decode(tokens: tokens)
                        Task { @MainActor in
                            self.output = text
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
            if result.output != self.output {
                self.output = result.output
            }
            self.stat = " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"

        } catch {
            output = "Failed: \(error)"
        }

        running = false
    }
}
