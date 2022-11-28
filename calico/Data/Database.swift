//
//  Database.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import Foundation

/// In-memory persistence layer
struct Database {
    
    // In-memory data (tag + associated models)
    private var data: [String: [CatModel]] = [:]
}

extension Database {
    
    /// Save cats to in-memory storage
    mutating func save(_ cats: [CatModel], for tag: String) {
        data[tag] = cats
    }
    
    /// Fetch cats for a given tag from in-memory storage
    /// - Parameter tag: tag
    /// - Returns: array of cat models
    func fetchCats(with tag: String) -> [CatModel] {
        return data[tag] ?? []
    }
}
