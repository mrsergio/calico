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
                
            case .sliderPlain, .sliderWithOverlay:
                // Image width to fetch from API later
                let preferredSideSize = Int(relatedSectionType.itemSize.width * UIScreen.main.nativeScale)
                
                imageURL = catModel.url(
                    sizeType: .square,
                    preferredSideSize: preferredSideSize
                )
        }
    }
    
    init(id: String = UUID().uuidString, imageURLString: URL? = nil, originalImageURL: URL? = nil, relatedSectionType: CollectionSectionType, tag: String) {
        self.id = id
        self.imageURL = imageURLString
        self.originalImageURL = originalImageURL
        self.relatedSectionType = relatedSectionType
        self.tag = tag
    }
}
