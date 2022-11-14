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
    
    let viewController: HomeViewController
    let viewModel: HomeViewModel
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        viewModel = HomeViewModel()
        viewController = HomeViewController(viewModel: viewModel)
        
        viewController.didSelectItem
            .sink(receiveValue: { [weak self] (collectionItem: CollectionItem) in
                guard let strongSelf = self else { return }
                
                switch collectionItem.relatedSectionType {
                    case .sliderWithOverlay:
                        // handle mood section
                        break
                        
                    default:
                        strongSelf.openItemDetails(collectionItem)
                }
            })
            .store(in: &cancellables)
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
    
    /// Opens cat details screen (the one with a "Share" button)
    func openItemDetails(_ item: CollectionItem) {
        let itemDetailsView = DetailsView(url: item.originalImageURL, quote: Quote.randomQuote) { [weak self] in
            /* "Share" button handler */
            self?.viewController.shareItem(item)
        }
        
        let detailsViewController = UIHostingController(rootView: itemDetailsView)
        detailsViewController.popoverPresentationController?.sourceView = viewController.collectionView
        detailsViewController.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .pageSheet : .formSheet
        
        viewController.present(detailsViewController, animated: true)
    }
}
