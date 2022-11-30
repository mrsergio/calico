//
//  HomeViewModel.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit
import Combine

final class HomeViewModel: ObservableObject, DiffabledDataSnapshotGeneratable {
    
    internal var fetcher = Fetcher.shared
    
    @Published var data: [DisplayItem] = []
    
    init() {
        initData()
    }
}

extension HomeViewModel {
    
    private func initData() {
        // Predefine display sections
        data = [
            DisplayItem(
                section: CollectionSection(
                    type: .banner,
                    tag: "kitten"
                ),
                items: CollectionItem.createDummies(count: 4, sectionType: .banner)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .square,
                    header: "Must-Have Cats",
                    description: "Get started with these",
                    tag: "cute"
                ),
                items: CollectionItem.createDummies(count: 4, sectionType: .square)
            ),
            DisplayItem(
                section: CollectionSection(
                    type: .square,
                    header: "Everyone's Favorites",
                    description: "Gems from every corner",
                    tag: "fat"
                ),
                items: CollectionItem.createDummies(count: 4, sectionType: .square)
            )
        ]
    }
    
    func loadData() {
        // Load predefined sections
        loadPredefinedSections()
        
        // Load mood section (based on random tags)
        loadMoodSection()
    }
}
