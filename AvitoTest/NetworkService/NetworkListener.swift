//
//  NetworkManager.swift
//  AvitoTest
//
//  Created by Шарап Бамматов on 27.10.2022.
//

import Foundation
import Reachability

class NetworkListener : NSObject {
    
    static  let shared = NetworkListener()
    
    var reachabilityStatus: Reachability.Connection = .unavailable
    let reachability = try! Reachability()
    
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .unavailable
    }
    
    
    
    func startNWListener() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            print("Network not reachable")
        case .none:
            print("Network none")
        }
    }
    
    
}
