//
//  HomeViewModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit
import Alamofire
import Combine

class HomeViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let network = NetworkClient()
    
    let dataDidUpdate = PassthroughSubject<Void, Never>()
    private(set) var data: [DisplayItem] = []
    
    init() {
        setupData()
    }
    
    private func setupData() {
        // Predefine display sections
        data = [
            DisplayItem(
                section: CollectionSection(
                    type: .banner,
                    tag: "funny"
                ),
                items: createDummyItems(count: 4, sectionType: .banner)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .slider,
                    header: "Must-Have Cats",
                    description: "Get started with these",
                    tag: "cute"
                ),
                items: createDummyItems(count: 4, sectionType: .slider)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .slider,
                    header: "Everyone's Favorites",
                    description: "Gems from every corner",
                    tag: "fat"
                ),
                items: createDummyItems(count: 4, sectionType: .slider)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .slider,
                    header: "Cats by Mood",
                    description: ""
                ),
                items: createDummyItems(count: 4, sectionType: .slider)
            )
        ]
        
        // Load predefined sections with a data
        loadData()
    }
}

// MARK: - Network

extension HomeViewModel {
    
    /// Load items for an each predefined data section
    func loadData() {
        for (index, displayItem) in data.enumerated() {
            loadCats(by: displayItem.section.tag, limit: 20) { [weak self] result in
                switch result {
                    case .success(let cats):
                        // Filter out gifs due to often timeouts :(
                        self?.data[index].items = cats
                            .filter({ !$0.tags.contains("gif") })
                            .compactMap { CollectionItem(
                                from: $0,
                                relatedSectionType: displayItem.section.type
                            )}
                        
                        self?.dataDidUpdate.send(())
                        
                    case .failure(let failure):
                        print("Error happened: \(failure)")
                }
            }
        }
    }
    
    /// Load array of cat models from API
    /// - Parameters:
    ///   - tag: items with particular tag to fetch
    ///   - limit: limit of number of items to fetch
    ///   - callback: success or failure result to handle
    private func loadCats(
        by tag: String,
        limit: Int,
        callback: @escaping ((Result<[CatModel], AFError>) -> Void)
    ) {
        network
            .fetchByTag(tag, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                        
                    case .failure(let error):
                        callback(.failure(error))
                }
                
            } receiveValue: { (cats: [CatModel]) in
                callback(.success(cats))
            }
            .store(in: &cancellables)
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
    private func createDummyItems(count: Int, sectionType: CollectionSectionType) -> [CollectionItem] {
        guard count > 0 else {
            return []
        }
        
        return (0..<count)
            .map({ _ in CollectionItem(relatedSectionType: sectionType) })
    }
}
