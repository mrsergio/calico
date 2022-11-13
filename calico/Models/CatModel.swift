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

extension CatModel {
    
    /// Generate direct image URL
    /// - Example: https://cataas.com/cat/Rn6xqsiHb9B7qgLw?type=square&width=300
    /// - Parameter sizeType: `square` is preferred, others are: `small`, `medium`, `original`
    /// - Parameter preferredSideSize: preferred image width, use when you need to resize the image
    /// - Returns: direct URL to the image
    func url(sizeType: ImageSizeType, preferredSideSize: Int? = nil) -> URL {
        // Prepare URL query params
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "type", value: sizeType.rawValue)]
        
        if let preferredSideSize {
            queryItems.append(
                URLQueryItem(name: "width", value: String(preferredSideSize))
            )
        }
        
        // Build direct URL
        return NetworkAPI.url
            .appendingPathComponent("cat")
            .appendingPathComponent(id)
            .appending(queryItems: queryItems)
    }
}
