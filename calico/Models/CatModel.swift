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
