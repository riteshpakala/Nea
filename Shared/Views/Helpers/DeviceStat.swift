//
//  DeviceStat.swift
//  Nea
//
//  Created by Ritesh Pakala on 3/22/25.
//  From: https://github.com/ml-explore/mlx-swift-examples/blob/main/Applications/LLMEval/ViewModels/DeviceStat.swift

import Foundation
import MLX

@Observable
final class DeviceStat: @unchecked Sendable {

    @MainActor
    var gpuUsage = GPU.snapshot()

    private let initialGPUSnapshot = GPU.snapshot()
    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateGPUUsages()
        }
    }

    deinit {
        timer?.invalidate()
    }

    private func updateGPUUsages() {
        let gpuSnapshotDelta = initialGPUSnapshot.delta(GPU.snapshot())
        DispatchQueue.main.async { [weak self] in
            self?.gpuUsage = gpuSnapshotDelta
        }
    }

}
