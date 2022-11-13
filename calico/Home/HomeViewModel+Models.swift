//
//  HomeViewModel+Models.swift
//  calico
//
//  Created by Sergii Simakhin on 11/13/22.
//

import Foundation

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
        var imageURLString: String?
        
        init(from catModel: CatModel) {
            id = catModel.id
            imageURLString = catModel.url.absoluteString
        }
        
        init(id: String = UUID().uuidString, imageURLString: String? = nil) {
            self.id = id
            self.imageURLString = imageURLString
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
