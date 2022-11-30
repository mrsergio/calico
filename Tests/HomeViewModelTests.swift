//
//  HomeViewModelTests.swift
//  calico
//
//  Created by Sergii Simakhin on 11/29/22.
//

import Foundation
import XCTest
import Combine
@testable import calico

final class HomeViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testLoadPredefinedSections() async {
        let allPredefinedSectionsAreLoadedExpectation = expectation(description: "allPredefinedSectionsAreLoadedExpectation")
        
        let homeViewModel = HomeViewModel()
        
        await homeViewModel
            .loadPredefinedSections()
            .result
            .publisher
            .sink {
                // Check if all sections are loaded (or none of them are dummy)
                if homeViewModel.data.filter({ $0.isDummy }).count == 0 {
                    allPredefinedSectionsAreLoadedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Wait 10 seconds to load predefined sections
        await waitForExpectations(timeout: 10.0)
    }
    
    func testLoadMoodSections() async {
        let moodSectionIsLoadedExpectation = expectation(description: "moodSectionIsLoadedExpectation")
        
        let homeViewModel = HomeViewModel()
        
        await homeViewModel
            .loadMoodSection()
            .result
            .publisher
            .sink {
                // Fetch mood section
                guard let moodSection = homeViewModel.data.first(where: { $0.section.type == .wideWithOverlay }) else {
                    return
                }
                
                // We've loaded the mood section
                moodSectionIsLoadedExpectation.fulfill()
                
                // Make sure there are 10 or less items in a section
                XCTAssertTrue(moodSection.items.count <= 10)
            }
            .store(in: &cancellables)
        
        // Wait 10 seconds to load mood sections
        await waitForExpectations(timeout: 10.0)
    }
}
