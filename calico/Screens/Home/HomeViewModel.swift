//
//  HomeViewModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit
import Combine

class HomeViewModel {
    
    internal var cancellables = Set<AnyCancellable>()
    internal let network = NetworkClient()
    
    let dataDidUpdate = PassthroughSubject<Void, Never>()
    internal var data: [DisplayItem] = []
    
    init() {
        setupData()
    }
    
    private func setupData() {
        // Predefine display sections
        data = [
            DisplayItem(
                section: CollectionSection(
                    type: .banner,
                    tag: "kitten"
                ),
                items: createDummyCollectionItems(count: 4, sectionType: .banner)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .square,
                    header: "Must-Have Cats",
                    description: "Get started with these",
                    tag: "cute"
                ),
                items: createDummyCollectionItems(count: 4, sectionType: .square)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .square,
                    header: "Everyone's Favorites",
                    description: "Gems from every corner",
                    tag: "fat"
                ),
                items: createDummyCollectionItems(count: 4, sectionType: .square)
            )
        ]
        
        // Load predefined sections with a data
        loadPredefinedData()
        
        // Load mood section (based on fetched random tags)
        loadMoodSection()
    }
}

// MARK: - UICollectionView related helpers

extension HomeViewModel {
    
    /// Converts `data` to DiffableDataSource snapshot
    var dataSnapshot: NSDiffableDataSourceSnapshot<CollectionSection, CollectionItem> {
        // Init snapshot
        var snapshot = NSDiffableDataSourceSnapshot<CollectionSection, CollectionItem>()
        
        // Append sections
        let sections: [CollectionSection] = data.compactMap({ $0.section })
        snapshot.appendSections(sections)
        
        // Fill sections with items
        data.forEach { (displayItem: DisplayItem) in
            snapshot.appendItems(displayItem.items, toSection: displayItem.section)
        }
        
        return snapshot
    }
}

// MARK: - Helpers

extension HomeViewModel {
    
    /// Creates array of N number of unique `CollectionItem`
    private func createDummyCollectionItems(count: Int, sectionType: CollectionSectionType) -> [CollectionItem] {
        guard count > 0 else {
            return []
        }
        
        return (0..<count)
            .map({ _ in CollectionItem(relatedSectionType: sectionType, tag: "") })
    }
}
