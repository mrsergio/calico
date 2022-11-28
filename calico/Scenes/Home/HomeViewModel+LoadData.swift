//
//  HomeViewModel+LoadData.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import Combine

extension HomeViewModel {
    
    /// Load cats for an each predefined section
    func loadPredefinedSections() {
        Task {
            // Go thru each predefined section
            for (index, displayItem) in data.enumerated() {
                do {
                    let cats: [CatModel] = try await fetcher.fetchCatsFromAPI(by: displayItem.section.tag)
                    
                    // Shuffle the cats and take first 10 (to display in a UICollectionView horizontal slider)
                    let filteredCats: [CatModel] = Array(cats.shuffled().prefix(10))
                    
                    // Transform to UI models
                    let collectionItems: [CollectionItem] = filteredCats
                        .compactMap { CollectionItem(
                            from: $0,
                            relatedSectionType: displayItem.section.type,
                            tag: $0.tags.first ?? displayItem.section.tag
                        )}
                    
                    // Assign them on the main thread (so UI will update since `data` is a @Published object)
                    DispatchQueue.main.async { [weak self] in
                        self?.data[index].items = collectionItems
                    }
                    
                } catch {
                    print("Error happened: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Fetch tags, get a random couple of them and create a random tags section
    func loadMoodSection() {
        // Predefine mood section first
        let moodSection = CollectionSection(
            type: .wideWithOverlay,
            header: "Cats by Mood",
            description: ""
        )
        
        // Closure used to append cat item to the mood section
        let appendToMoodSection: ((CollectionItem) -> Void) = { [weak self] item in
            // Find out mood section index first
            if let moodSectionIndex = self?.data.firstIndex(where: { $0.section.id == moodSection.id }) {
                // Append item to the mood section
                self?.data[moodSectionIndex].items.append(item)
                
            } else {
                // There are no mood section found, create a new one
                let catsByMoodDisplayItem = DisplayItem(
                    section: moodSection,
                    items: [item] // passed item used as a first item in this just created section
                )
                
                // Add mood section to the data
                self?.data.append(catsByMoodDisplayItem)
            }
        }
        
        // Background loading process
        Task {
            do {
                // Fetch a list of random tags
                let randomTags: [String] = try await fetcher.fetchRandomTags()
                
                // Fetch cats for an each tag
                for tag in randomTags {
                    let fetchedCats: [CatModel] = try await fetcher.fetchCatsFromAPI(by: tag)
                    
                    // We need only 1 cat to append as a section item (consider it as a preview item)
                    guard let cat: CatModel = fetchedCats.first else {
                        continue
                    }
                    
                    // Convert it into the CollectionItem
                    let collectionItem = CollectionItem(
                        from: cat,
                        relatedSectionType: .wideWithOverlay,
                        tag: tag
                    )
                    
                    // And append to the mood section
                    DispatchQueue.main.async {
                        appendToMoodSection(collectionItem)
                    }
                }
                
            } catch {
                print("Error happened: \(error.localizedDescription)")
            }
        }
    }
}
