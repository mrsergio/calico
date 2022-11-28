//
//  NetworkMonitor.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import Foundation
import Network
import Combine

enum NetworkStatus {
    case connected, notConnected
    
    init(from pathStatus: NWPath.Status) {
        switch pathStatus {
            case .satisfied:
                self = .connected
                
            default:
                self = .notConnected
        }
    }
}

final class NetworkMonitor: NSObject, ObservableObject {
    
    public static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    @Published var status: NetworkStatus = .connected
    
    public var isConnected: Bool {
        return status == .connected
    }
    
    override init() {
        let queue = DispatchQueue(label: "calico.network.monitor")
        monitor.start(queue: queue)
    }
}

extension NetworkMonitor {
    
    func startObserving() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let strongSelf = self else {
                return
            }
            
            let previousStatus: NetworkStatus = strongSelf.status
            let newStatus = NetworkStatus(from: path.status)
            
            // Ignore if new status is the same as was before
            guard newStatus != previousStatus else {
                return
            }
            
            self?.status = newStatus
        }
    }
}
