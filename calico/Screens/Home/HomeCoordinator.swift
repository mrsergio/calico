//
//  HomeCoordinator.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit
import Combine
import SwiftUI

final class HomeCoordinator {
    
    private var cancellables = Set<AnyCancellable>()
    private var navigationController: UINavigationController?
    
    private let viewController: HomeViewController
    private let viewModel: HomeViewModel
    
    private var seeAllCoordinator: SeeAllCoordinator?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        viewModel = HomeViewModel()
        viewController = HomeViewController(viewModel: viewModel)
        
        setupActionHandlers()
    }
}

extension HomeCoordinator: Coordinator {
    
    var key: Coordinators {
        .home
    }
    
    func start() {
        navigationController?.setViewControllers([viewController], animated: false)
    }
}

extension HomeCoordinator {
    
    private func setupActionHandlers() {
        viewController.didSelectItem
            .sink(receiveValue: { [weak self] (indexPath: IndexPath) in
                guard let strongSelf = self else {
                    return
                }
                
                // Fetch associated collectionItem from the viewModel
                let collectionItem = strongSelf.viewModel
                    .data[indexPath.section]
                    .items[indexPath.item]
                
                // Perform an action depending on the section type
                switch (collectionItem.relatedSectionType, collectionItem.tag) {
                    case (.wideWithOverlay, let tag):
                        strongSelf.openSeeAll(tag)
                        
                    default:
                        strongSelf.openItemDetails(
                            collectionItem,
                            from: strongSelf.viewController
                        )
                }
            })
            .store(in: &cancellables)
        
        viewController.didTapSeeAllForSection
            .sink { [weak self] (collectionSection: CollectionSection) in
                self?.openSeeAll(collectionSection.tag)
            }
            .store(in: &cancellables)
    }
    
    /// Opens cat details screen (the one with a "Share" button)
    func openItemDetails(_ item: CollectionItem, from vc: UIViewController) {
        let itemDetailsView = DetailsView(url: item.originalImageURL, quote: Quote.randomQuote) {
            /* "Share" button handler */
            vc.shareItem(item)
        }
        
        let detailsViewController = UIHostingController(rootView: itemDetailsView)
        detailsViewController.popoverPresentationController?.sourceView = vc.view
        detailsViewController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .pageSheet : .formSheet
        
        vc.present(detailsViewController, animated: true)
    }
    
    /// Opens 'See All' view controller to see all the cats for a particular tag
    private func openSeeAll(_ tag: String) {
        let seeAllCoordinator = SeeAllCoordinator(
            navigationController: navigationController,
            tag: tag
        )
        
        seeAllCoordinator.displayCollectionItem
            .sink { [weak self] (collectionItem: CollectionItem, viewController: UIViewController) in
                self?.openItemDetails(collectionItem, from: viewController)
            }
            .store(in: &cancellables)
        
        seeAllCoordinator.didDisappear
            .sink { [weak self] _ in
                // Remove the coordinator reference to release it from the memory
                self?.seeAllCoordinator = nil
            }
            .store(in: &cancellables)
        
        // Keep coordinator reference while user is there
        self.seeAllCoordinator = seeAllCoordinator
        
        // Display the coordinator
        seeAllCoordinator.start()
    }
}
