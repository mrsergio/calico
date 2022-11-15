//
//  HomeViewModel+Network.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import Alamofire
import Combine

extension HomeViewModel {
    
    /// Load items for an each predefined data section
    func loadPredefinedData() {
        for (index, displayItem) in data.enumerated() {
            loadCats(by: displayItem.section.tag, limit: 20) { [weak self] result in
                switch result {
                    case .success(let cats):
                        // Filter out images with no tags and gifs due to often timeouts :(
                        self?.data[index].items = cats
                            .filter({ !$0.tags.isEmpty })
                            .filter({ !$0.tags.contains("gif") })
                            .shuffled()
                            .compactMap { CollectionItem(
                                from: $0,
                                relatedSectionType: displayItem.section.type,
                                tag: $0.tags.first ?? displayItem.section.tag
                            )}
                        
                        self?.dataDidUpdate.send(())
                        
                    case .failure(let failure):
                        print("Error happened: \(failure)")
                }
            }
        }
    }
    
    /// Load array of cat models from API
    /// - Parameters:
    ///   - tag: items with particular tag to fetch
    ///   - limit: limit of number of items to fetch
    ///   - callback: success or failure result to handle
    private func loadCats(
        by tag: String,
        limit: Int,
        callback: @escaping ((Result<[CatModel], AFError>) -> Void)
    ) {
        network
            .fetchByTag(tag, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                        
                    case .failure(let error):
                        callback(.failure(error))
                }
                
            } receiveValue: { (cats: [CatModel]) in
                callback(.success(cats))
            }
            .store(in: &cancellables)
    }
    
    /// Load array of 5 random tags from API
    /// - Parameter callback: success of failure result to handle
    func loadRandomTags(callback: @escaping ((Result<[String], AFError>) -> Void)) {
        network
            .fetchAvailableTags()
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                        
                    case .failure(let error):
                        callback(.failure(error))
                }
                
            } receiveValue: { (tags: [String]) in
                let randomTags = tags
                    .filter({ !$0.isEmpty })
                    .filter({ $0.count < 10 })
                    .shuffled()
                    .prefix(5)
                
                callback(.success(Array(randomTags)))
            }
            .store(in: &cancellables)
    }
    
    
    /// Fetch tags, get random 5 of them and create a section using those tags for user to select later
    func loadMoodSection() {
        // Predefine mood section first
        let moodSection = CollectionSection(
            type: .sliderWithOverlay,
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
                    items: [item] // passed item used as first section item
                )
                
                // Add mood section to the data
                self?.data.append(catsByMoodDisplayItem)
            }
        }
        
        // Fetch Tags -> get random 5 of them -> fetch 1 cat for an each tag
        network
            .fetchAvailableTags()
            .flatMap({ (tags: [String]) in
                let numberOfRandomTagsToFilterOut = 5
                
                let randomTags = tags
                    .filter({ !$0.isEmpty }) // filter out empty tags
                    .filter({ !$0.contains("gif") }) // filter out gif animations
                    .filter({ $0.count < 10 }) // filter out long tags
                    .shuffled()
                    .prefix(numberOfRandomTagsToFilterOut) // take first N items
                
                return Just(Array(randomTags))
            })
            .sink(receiveCompletion: { _ in
                // Do nothing
            }, receiveValue: { [weak self] (randomTags: [String]) in
                guard let strongSelf = self else {
                    return
                }
                
                // Fetch 1 cat model for an each tag
                for tag in randomTags {
                    strongSelf.network.fetchByTag(tag, limit: 1)
                        .sink(receiveCompletion: { completion in
                            // Let subscribers know they need to update UI
                            strongSelf.dataDidUpdate.send(())
                            
                        }, receiveValue: { (cats: [CatModel]) in
                            // Get the cat model
                            guard let catModel = cats.first else {
                                return
                            }
                            
                            // Convert it into the CollectionItem
                            let itemModel = CollectionItem(
                                from: catModel,
                                relatedSectionType: .wideWithOverlay,
                                tag: tag
                            )
                            
                            // And append to the mood section
                            appendToMoodSection(itemModel)
                            
                            // UI update will be triggered from the completion closure above ^^^
                        })
                        .store(in: &strongSelf.cancellables)
                }
            })
            .store(in: &cancellables)
    }
}
