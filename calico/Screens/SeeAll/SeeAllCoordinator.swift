//
//  SeeAllCoordinator.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class SeeAllCoordinator {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var navigationController: UINavigationController?
    private var tag: String
    
    private let viewController: SeeAllViewController
    private let viewModel: SeeAllViewModel
    
    let displayCollectionItem = PassthroughSubject<(CollectionItem, UIViewController), Never>()
    let willDisappear = PassthroughSubject<Void, Never>()
    
    init(navigationController: UINavigationController?, tag: String) {
        self.navigationController = navigationController
        self.tag = tag
        
        viewModel = SeeAllViewModel(tag: tag)
        viewController = SeeAllViewController(viewModel: viewModel)
        
        setupActionHandlers()
    }
}

extension SeeAllCoordinator: Coordinator {
    
    var key: Coordinators {
        .seeAll
    }
    
    func start() {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SeeAllCoordinator {
    
    private func setupActionHandlers() {
        viewController.didSelectItem
            .sink(receiveValue: { [weak self] (indexPath: IndexPath) in
                guard let strongSelf = self else {
                    return
                }
                
                // Fetch the item to display
                let collectionItem = strongSelf.viewModel
                    .data[indexPath.section]
                    .items[indexPath.item]
                
                // Ask to display selected collection item from current view controller]
                strongSelf.displayCollectionItem
                    .send((collectionItem, strongSelf.viewController))
            })
            .store(in: &cancellables)
        
        viewController.willDisappear
            .sink { [weak self] _ in
                // Using to deallocate current coordinator from the parent one
                self?.willDisappear.send(())
            }
            .store(in: &cancellables)
    }
}
