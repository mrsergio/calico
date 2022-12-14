//
//  DisplayItem.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation

struct DisplayItem {
    let section: CollectionSection
    var items: [CollectionItem]
    
    var sectionHeight: CGFloat {
        section.type.sectionHeight
    }
    
    var itemSize: CGSize {
        section.type.itemSize
    }
    
    var sectionHeader: String {
        section.header
    }
    
    var sectionDescription: String {
        section.description
    }
    
    var isDummy: Bool {
        // Display section considered as dummy is all the items are dummy
        items.filter({ $0.isDummy }).count == items.count
    }
}

extension DisplayItem {
    
    var itemsPreviewURLs: [URL] {
        return items.compactMap({ $0.imageURL })
    }
    
    var itemsOriginalURLs: [URL] {
        return items.compactMap({ $0.originalImageURL })
    }
}
