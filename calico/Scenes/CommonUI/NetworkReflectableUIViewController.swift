//
//  NetworkReflectableUIViewController.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import UIKit
import Combine
import SwiftUI

class NetworkReflectableUIViewController: UIViewController {
    
    internal var cancellables = Set<AnyCancellable>()
    
    func setupNoNetworkView() {
        guard let noNetworkView = UIHostingController(rootView: NoNetworkConnectionView()).view else {
            return
        }
        noNetworkView.translatesAutoresizingMaskIntoConstraints = false
        noNetworkView.backgroundColor = UIColor.clear
        
        view.addSubview(noNetworkView)
        NSLayoutConstraint.activate([
            noNetworkView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noNetworkView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noNetworkView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func followNetworkStatusUpdates(
        onConnected: @escaping (() -> Void),
        onNotConnected: @escaping (() -> Void),
        viewToDisplayWhenConnected: UIView
    ) {
        NetworkMonitor.shared
            .$status
            .dropFirst() // ignore initial value assignment
            .receive(on: DispatchQueue.main)
            .sink { (status: NetworkStatus) in
                switch status {
                    case .connected:
                        onConnected()
                        
                        // Display view, so 'no network connection' view stay underneath
                        viewToDisplayWhenConnected.isHidden = false
                        
                    case .notConnected:
                        onNotConnected()
                        
                        // Hide view to display 'no network connection' view underneath
                        viewToDisplayWhenConnected.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
}
