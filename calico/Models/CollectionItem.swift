//
//  CollectionItem.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import UIKit

struct CollectionItem: Hashable {
    var id: String
    var imageURL: URL?
    var originalImageURL: URL?
    var isDummy: Bool = false
    
    var relatedSectionType: CollectionSectionType
    var tag: String
    
    init(from catModel: CatModel, relatedSectionType: CollectionSectionType, tag: String) {
        self.id = UUID().uuidString
        self.relatedSectionType = relatedSectionType
        self.tag = tag
        self.originalImageURL = catModel.url(sizeType: .original)
        
        switch relatedSectionType {
            case .banner:
                imageURL = catModel.url(
                    sizeType: .original
                )
                
            case .square, .wideWithOverlay:
                // Image width to fetch from API later
                let preferredSideSize = Int(relatedSectionType.itemSize.width * UIScreen.main.nativeScale)
                
                imageURL = catModel.url(
                    sizeType: .square,
                    preferredSideSize: preferredSideSize
                )
        }
    }
    
    init(id: String = UUID().uuidString, imageURLString: URL? = nil, originalImageURL: URL? = nil, relatedSectionType: CollectionSectionType, tag: String, isDummy: Bool = false) {
        self.id = id
        self.imageURL = imageURLString
        self.originalImageURL = originalImageURL
        self.relatedSectionType = relatedSectionType
        self.tag = tag
        self.isDummy = isDummy
    }
}

extension CollectionItem {
    
    /// Creates array of N number of unique `CollectionItem`
    static func createDummies(count: Int, sectionType: CollectionSectionType) -> [CollectionItem] {
        guard count > 0 else {
            return []
        }
        
        return (0..<count)
            .map({ _ in CollectionItem(
                relatedSectionType: sectionType,
                tag: "",
                isDummy: true
            ) })
    }
}
