//
//  DiffabledDataSnapshotGeneratable.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import Foundation
import UIKit

/// Used for ViewModels with display data array and who use UICollectionView to display its data
protocol DiffabledDataSnapshotGeneratable {
    var data: [DisplayItem] { get set }
    var dataSnapshot: NSDiffableDataSourceSnapshot<CollectionSection, CollectionItem> { get }
}

extension DiffabledDataSnapshotGeneratable {
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
