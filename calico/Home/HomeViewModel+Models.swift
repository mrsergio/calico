//
//  HomeViewModel+Models.swift
//  calico
//
//  Created by Sergii Simakhin on 11/13/22.
//

import Foundation
import UIKit

extension HomeViewModel {
    
    enum CollectionSectionType {
        case banner, slider
        
        var sectionHeight: CGFloat {
            switch self {
                case .banner: return 200.0
                case .slider: return 144.0
            }
        }
        
        var itemSize: CGSize {
            // Banner item size width will be ignored since it is equal to the screen width
            switch self {
                case .banner: return CGSize(width: 200, height: 200)
                case .slider: return CGSize(width: 120, height: 120)
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
    
    struct CollectionItem: Hashable {
        var id: String
        var imageURL: URL?
        var relatedSectionType: CollectionSectionType
        
        init(from catModel: CatModel, relatedSectionType: CollectionSectionType) {
            self.id = UUID().uuidString
            self.relatedSectionType = relatedSectionType
            
            switch relatedSectionType {
                case .banner:
                    imageURL = catModel.url(
                        sizeType: .original
                    )
                    
                case .slider:
                    imageURL = catModel.url(
                        sizeType: .square,
                        preferredSideSize: Int(relatedSectionType.itemSize.width * UIScreen.main.nativeScale)
                    )
            }
        }
        
        init(id: String = UUID().uuidString, imageURLString: URL? = nil, relatedSectionType: CollectionSectionType) {
            self.id = id
            self.imageURL = imageURLString
            self.relatedSectionType = relatedSectionType
        }
    }
    
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
    }
}
