//
//  CollectionSection.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation

enum CollectionSectionType: Hashable {
    case banner, sliderPlain, sliderWithOverlay
    
    var sectionHeight: CGFloat {
        switch self {
            case .banner: return 200.0
            case .sliderPlain: return 144.0
            case .sliderWithOverlay: return 200.0
        }
    }
    
    var itemSize: CGSize {
        // Banner item size width will be ignored since it is equal to the screen width
        switch self {
            case .banner: return CGSize(width: 200, height: 200)
            case .sliderPlain: return CGSize(width: 120, height: 120)
            case .sliderWithOverlay: return CGSize(width: 180, height: 100)
        }
    }
}

struct CollectionSection: Hashable {
    var id: String = UUID().uuidString
    var type: CollectionSectionType
    
    var header: String = ""
    var description: String = ""
    var tag: String = ""
}
