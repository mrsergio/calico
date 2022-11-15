//
//  CollectionSection.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import UIKit

enum CollectionSectionType: Hashable {
    case banner, square, wideWithOverlay
    
    var sectionHeight: CGFloat {
        switch self {
            case .banner: return UIDevice.current.userInterfaceIdiom == .pad ? 400.0 : 200.0
            case .square: return UIDevice.current.userInterfaceIdiom == .pad ? 180.0 : 144.0
            case .wideWithOverlay: return UIDevice.current.userInterfaceIdiom == .pad ? 144.0 : 120.0
        }
    }
    
    var itemSize: CGSize {
        // Banner item size width will be ignored since it is equal to the screen width
        switch self {
            case .banner:
                return UIDevice.current.userInterfaceIdiom == .pad
                ? CGSize(width: 400, height: 400)
                : CGSize(width: 200, height: 200)
                
            case .square:
                return UIDevice.current.userInterfaceIdiom == .pad
                ? CGSize(width: 156, height: 156)
                : CGSize(width: 120, height: 120)
                
            case .wideWithOverlay:
                return UIDevice.current.userInterfaceIdiom == .pad
                ? CGSize(width: 200, height: 120)
                : CGSize(width: 180, height: 100)
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
