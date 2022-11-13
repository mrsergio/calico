//
//  CatModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/13/22.
//

import Foundation

struct CatModel: Decodable {
    
    let id: String
    let tags: [String]
    
    var url: URL {
        // Example: https://cataas.com/cat/Rn6xqsiHb9B7qgLw
        NetworkAPI.url.appendingPathComponent("cat").appendingPathComponent(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case tags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        tags = try container.decode([String].self, forKey: .tags)
    }
}
