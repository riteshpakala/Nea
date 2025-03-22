//
//  LLMModels.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 3/22/25.
//

import MLXLMCommon
import Foundation

struct LLMModels {
    struct DeepSeek {
        struct Local {
            // 278m
            static public let r1_distill_qwen_nano = ModelConfiguration(
                directory: URL(filePath: "/Users/ritesh/Documents/ml/models/llm/DeepSeek-R1-Distill-Qwen-1.5B-4bit", directoryHint: .isDirectory)!,
                defaultPrompt: "What does Eppur si muove mean?"
            )
            // 5.12b
            static public let r1_32_distill_qwen_4bit = ModelConfiguration(
                directory: URL(filePath: "/Users/ritesh/Documents/ml/models/llm/DeepSeek-R1-Distill-Qwen-32B-4Bit", directoryHint: .isDirectory)!,
                defaultPrompt: "What does Eppur si muove mean?"
            )
            // 9.22b
            static public let r1_32_distill_qwen_8bit = ModelConfiguration(
                directory: URL(filePath: "/Users/ritesh/Documents/ml/models/llm/DeepSeek-R1-Distill-Qwen-32B-MLX-8Bit", directoryHint: .isDirectory)!,
                defaultPrompt: "What does Eppur si muove mean?"
            )
        }
        // 1.78b
        static public let r1_distill_qwen = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/deepseek-r1-distill-qwen-1.5b", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        // 278m
        static public let r1_distill_qwen_nano = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/DeepSeek-R1-Distill-Qwen-1.5B-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        // 9.22b ⛔️
        static public let r1_32_distill_qwen_8bit = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/DeepSeek-R1-Distill-Qwen-32B-MLX-8Bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        // 5.12b
        static public let r1_32_distill_qwen_4bit = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/DeepSeek-R1-Distill-Qwen-32B-4Bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        // 8.82b ⛔️
        static public let r1_distill_llama = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/DeepSeek-R1-Distill-Llama-70B-3bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        // 1.67b
        static public let r1_7_distill_qwen_6bit = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/DeepSeek-R1-Distill-Qwen-7B-6bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
    }
    struct Meta {
        // 1.25b
        static public let llama = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/Meta-Llama-3.1-8B-Instruct-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
    }
    struct Mistral {
        // 3.44b
        static public let nemo = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/Mistral-Nemo-Instruct-2407-8bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        
        // 3.68b ⛔️
        static public let small = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/Mistral-Small-24B-Instruct-2501-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        
        // 19.2b
        static public let large = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/Mistral-Large-Instruct-2407-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
    }
    struct Qwen {
        struct Local {
            // 9.22b
            static public let coder_32 = ModelConfiguration(
                directory: URL(filePath: "/Users/ritesh/Documents/ml/models/llm/Qwen2.5-Coder-32B-Instruct-4bit", directoryHint: .isDirectory)!,
                defaultPrompt: "What does Eppur si muove mean?"
            )
        }
        // 9.22b ⛔️
        static public let coder_32 = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/Qwen2.5-Coder-32B-Instruct-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
        
        // 2.31b
        static public let coder_14 = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/Qwen2.5-Coder-14B-Instruct-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
    }
    struct QwQ {
        // 5.12b ⛔️
        static public let small = ModelConfiguration(
            directory: URL(filePath: "/Volumes/T9/models/llm/QwQ-32B-4bit", directoryHint: .isDirectory)!,
            defaultPrompt: "What does Eppur si muove mean?"
        )
    }
    
    fileprivate static var documentsDirectory: URL {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentDirectory
        } else {
            return URL(filePath: "/Users/ritesh/Documents")!
        }
    }
}
