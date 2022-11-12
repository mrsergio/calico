//
//  AppCoordinator.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//
//  AppCoordinator is an entry point of the app.
//

import Foundation
import UIKit

final class AppCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
}

extension AppCoordinator: Coordinator {
    var key: Coordinators {
        .app
    }
    
    func start() {
        //
    }
    
    
}
