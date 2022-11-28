//
//  Fetcher.swift
//  calico
//
//  Created by Sergii Simakhin on 11/28/22.
//

import Foundation
import NetworkClient

/// Fetch layer used to request the data from database or network
final class Fetcher {
    static let shared = Fetcher()
    
    private var database = Database()
    private let network = NetworkClient()
}

extension Fetcher {
    
    /// Fetch cats from database
    func fetchCatsFromDatabase(by tag: String) -> [CatModel] {
        return database.fetchCats(with: tag)
    }
    
    /// Fetch cats from API for a given tag (result will be saved in local database)
    /// Result will be saved in a local database, so next time we would not need to fetch from API again.
    /// - Parameters:
    ///   - tag: associated tag
    ///   - limit: number of items to fetch (0 is no limit)
    /// - Returns: cat models array associated with given tag
    func fetchCatsFromAPI(by tag: String, limit: Int = 0) async throws -> [CatModel] {
        let cats: [CatModel] = try await network
            .fetchByTag([CatModel].self, tag: tag, limit: limit)
            .filter({ !$0.tags.isEmpty }) // filter out cat models with no tags
            .filter({ !$0.tags.contains("gif") }) // filter out cat models with 'gif' tag due to often loading timeouts
        
        // Save cats to the database (so next time we would not need to load it from network)
        database.save(cats, for: tag)
        
        return cats
    }
    
    /// Fetch 10 (or less) random tags from API
    /// - Returns: string array of random tags
    func fetchRandomTags() async throws -> [String] {
        let tags: [String] = try await network.fetchAvailableTags()
        
        let filteredTags: [String] = tags
            .filter({ !$0.isEmpty }) // filter out empty tags
            .filter({ !$0.contains("gif") }) // filter out gif animations
            .filter({ $0.count < 16 }) // filter out tags with long names
        
        let randomTags: [String] = Array(filteredTags
            .shuffled()
            .prefix(10)
        )
        
        return randomTags
    }
}
