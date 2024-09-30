//
//  ReachabilityManager.swift
//  TestTask
//
//  Created by Vladyslav Pavelko on 30.09.2024.
//

import Network
import SwiftUI

class ReachabilityManager: ObservableObject {
    private var monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)

    @Published var isConnected: Bool = true

    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

