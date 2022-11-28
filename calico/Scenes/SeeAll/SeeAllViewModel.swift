//
//  SeeAllViewModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import Combine

final class SeeAllViewModel: ObservableObject, DiffabledDataSnapshotGeneratable {
    
    private(set) var tag: String
    @Published var data: [DisplayItem] = []
    
    init(tag: String) {
        self.tag = tag
        setupData(with: tag)
    }
    
    private func setupData(with tag: String) {
        // Fetch section items from database
        let sectionItems = Fetcher.shared.fetchCatsFromDatabase(by: tag)
        let collectionItems = sectionItems
            .compactMap({ CollectionItem(
                from: $0,
                relatedSectionType: .square,
                tag: tag)
            })
        
        // Populate the section to display
        data = [
            DisplayItem(
                section: CollectionSection(
                    type: .square,
                    tag: tag
                ),
                items: collectionItems
            )
        ]
    }
}
