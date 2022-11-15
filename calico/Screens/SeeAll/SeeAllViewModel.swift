//
//  SeeAllViewModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import Combine

class SeeAllViewModel: DiffabledDataSnapshotGeneratable {
    
    internal var cancellables = Set<AnyCancellable>()
    internal let network = NetworkClient()
    
    let dataDidUpdate = PassthroughSubject<Void, Never>()
    internal var data: [DisplayItem] = []
    private(set) var tag: String
    private var alreadyLoadedData: Bool = false
    
    init(tag: String) {
        self.tag = tag
        setupData(with: tag)
    }
    
    private func setupData(with tag: String) {
        data = [
            DisplayItem(
                section: CollectionSection(
                    type: .square,
                    tag: tag
                ),
                items: fetchCollectionItemsForInitialDisplay()
            )
        ]
    }
}

extension SeeAllViewModel {
    
    private func fetchCollectionItemsForInitialDisplay() -> [CollectionItem] {
        // Check DataManager if we already have fetched the data earlier
        if DataManager.shared.fetchedTags.contains(tag) {
            // Yes, we've fetched the cats for a given tag earlier, now fetch them from in-memory storage
            let collectionItems = DataManager.shared
                .fetchCats(with: tag)
                .compactMap({ CollectionItem(
                    from: $0,
                    relatedSectionType: .square,
                    tag: tag)
                })
            
            // Let view model now we no longer need to fetch the items from API when requested
            alreadyLoadedData = true
            
            return collectionItems
            
        } else {
            // No, we haven't fetch the cats for a given tag earlier, return dummy items for now
            return CollectionItem.createDummies(
                count: 12,
                sectionType: .square
            )
        }
    }
    
    /// Fetch cats by tag from API, ignored if data has been already fetched from in-memory storage earlier
    func loadData() {
        guard !alreadyLoadedData else {
            return
        }
        
        DataManager.shared.loadCats(by: tag) { [weak self] result in
            switch result {
                case .success(let cats):
                    self?.data[0].items = cats
                        .compactMap { CollectionItem(
                            from: $0,
                            relatedSectionType: .square,
                            tag: self?.tag ?? ""
                        )}
                    
                    self?.dataDidUpdate.send(())
                    
                case .failure(let failure):
                    print("Error happened: \(failure)")
            }
        }
    }
}
