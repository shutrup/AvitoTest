//
//  NetworkMonitor.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 19.10.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case internet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            self.isConnected = path.status != .unsatisfied
            self.getConnectionType(path)
        }
    }

    func stopMonitoring() {
        monitor.cancel()
    }
    
    func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        
        if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        
        if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .internet
        } else {
            connectionType = .unknown
        }
    }
    
}
