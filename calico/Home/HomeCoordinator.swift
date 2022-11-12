//
//  HomeCoordinator.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit

final class HomeCoordinator {
    
    private var window: UIWindow
    var navigationController: UINavigationController?
    
    let viewController: HomeViewController
    let viewModel: HomeViewModel
    
    init(window: UIWindow) {
        self.window = window
        
        viewModel = HomeViewModel()
        viewController = HomeViewController(viewModel: viewModel)
    }
}

extension HomeCoordinator: Coordinator {
    
    var key: Coordinators {
        .home
    }
    
    func start() {
        navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
