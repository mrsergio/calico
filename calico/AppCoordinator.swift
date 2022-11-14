//
//  AppCoordinator.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//
//  AppCoordinator is an entry point of the app
//

import Foundation
import UIKit

final class AppCoordinator {
    
    let window: UIWindow
    
    // App main navigation controller
    private let navigationController = UINavigationController()
    
    // Keep reference to home coordinator to not let him deallocate (until we need so)
    private let homeCoordinator: HomeCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        homeCoordinator = HomeCoordinator(navigationController: navigationController)
    }
}

extension AppCoordinator: Coordinator {
    
    var key: Coordinators {
        .app
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        homeCoordinator?.start()
    }
}
