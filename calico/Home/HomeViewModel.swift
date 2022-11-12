//
//  HomeViewModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit

struct HomeViewModel {
    
    enum CollectionSectionType {
        case banner, slider
        
        var sectionHeight: CGFloat {
            switch self {
                case .banner: return 200.0
                case .slider: return 144.0
            }
        }
        
        var itemSize: CGSize {
            // Banner item size width will be ignored since it is equal to the screen width
            switch self {
                case .banner: return CGSize(width: 200, height: 200)
                case .slider: return CGSize(width: 120, height: 120)
            }
        }
    }
    
    struct CollectionSection: Hashable {
        
        var id: String = UUID().uuidString
        var type: CollectionSectionType
        
        var header: String = ""
        var description: String = ""
    }
    
    struct CollectionItem: Hashable {
        
        var id: String = UUID().uuidString
        var imageURLString: String?
    }
    
    struct DisplayItem {
        let section: CollectionSection
        let items: [CollectionItem]
        
        var sectionHeight: CGFloat {
            section.type.sectionHeight
        }
        
        var itemSize: CGSize {
            section.type.itemSize
        }
        
        var sectionHeader: String {
            section.header
        }
        
        var sectionDescription: String {
            section.description
        }
    }
    
    var data: [DisplayItem] = []
    
    init() {
        data = [
            DisplayItem(
                section: CollectionSection(type: .banner),
                items: [
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328")
                ]
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .slider,
                    header: "Must-Have Cats",
                    description: "Get started with these"
                ),
                items: [
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328")
                ]
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .slider,
                    header: "Everyone's Favorites",
                    description: "Gems from every corner"
                ),
                items: [
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328")
                ]
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .slider,
                    header: "Cats by Mood",
                    description: ""
                ),
                items: [
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328"),
                    CollectionItem(imageURLString: "https://cataas.com/cat?width=328")
                ]
            )
        ]
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
