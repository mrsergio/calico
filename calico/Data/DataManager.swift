//
//  DataManager.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import Foundation
import Combine
import Alamofire

class DataManager {
    
    static let shared = DataManager()
    
    private let network = NetworkClient()
    private var cancellables = Set<AnyCancellable>()
    
    // List of all cat models app fetched earlier
    private var allCats: [CatModel] = []
    
    // List of all tags app fetched cats for
    private(set) var fetchedTags: [String] = []
    
    /// Persist cats to in-memory storage (repeating ones are excluded)
    /// - Parameter cats: cats to persist
    private func save(_ cats: [CatModel]) {
        cats
            .filter { cat in
                // Filter out already added cats
                return !allCats.contains(where: { $0.id == cat.id })
            }
            .forEach { cat in
                allCats.append(cat)
            }
    }
    
    /// Fetch cats for a given tag from in-memory storage
    /// - Parameter tag: tag
    /// - Returns: array of cat models
    func fetchCats(with tag: String) -> [CatModel] {
        return allCats.filter({ $0.tags.contains(tag) })
    }
}

extension DataManager {
    
    /// Load array of cat models from API
    /// - Parameters:
    ///   - tag: items with particular tag to fetch
    ///   - limit: limit of number of items to fetch (0 equals to no limit)
    ///   - callback: success or failure result to handle
    func loadCats(
        by tag: String,
        limit: Int = 0,
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
                
            } receiveValue: { [weak self] (cats: [CatModel]) in
                /**
                 - filter out cat models with no tags
                 - filter out cat models with 'gif' tag due to often loading timeouts
                 - shuffle before save to randomize display order on each launch
                 */
                let filteredCats = cats
                    .filter({ !$0.tags.isEmpty })
                    .filter({ !$0.tags.contains("gif") })
                    .shuffled()
                
                // Persist cats to the in-memory storage
                self?.save(filteredCats)
                
                // Persist tag to the already fetched tag list
                self?.fetchedTags.append(tag)
                
                callback(.success(filteredCats))
            }
            .store(in: &cancellables)
    }
}
