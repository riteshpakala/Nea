//
//  SandClient.Tokenizer.swift
//  Nea
//
//  Created by Ritesh Pakala Rao on 5/13/23.
//

import Foundation
import Combine

//TODO: is this still needed? Seems as though independant instances were focused on
class SandClientTokenizerKit {
    @Published var tokenCount: Int = 0
    
    let operationQueue: OperationQueue = .init()
    
    init() {
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInteractive
    }
    
    func update(_ query: String) {
        guard query.isNotEmpty else {
            tokenCount = 0
            return
        }
        
        operationQueue.addOperation {
            DispatchQueue.main.async {
                self.tokenCount = SandClient.shared.gpt3Tokenizer.encoder.enconde(text: query).count
            }
        }
    }
}

//TODO: is this still needed? Seems as though independant instances were focused on
class SandClientTokenizerManager: ObservableObject {
    static let shared: SandClientTokenizerManager = .init()
    internal var cancellables = Set<AnyCancellable>()
    
    let kit: SandClientTokenizerKit
    
    @Published var tokenCount: Int = 0
    @Published var pause: Bool = false
    
    init() {
        kit = .init()
        observe()
    }
    
    private func observe() {
        kit.$tokenCount
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
            self?.tokenCount = newValue
            guard SandClientTokenizerManager.shared.pause == false else { return }
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    public static func update(_ query: String) {
        guard SandClientTokenizerManager.shared.pause == false else { return }
        SandClientTokenizerManager.shared.kit.update(query)
    }
    
    public static var tokenCount: Int {
        SandClientTokenizerManager.shared.tokenCount
    }
}
