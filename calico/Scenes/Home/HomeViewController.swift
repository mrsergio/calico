//
//  HomeViewController.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import Kingfisher

final class HomeViewController: NetworkReflectableUIViewController {
    
    // MARK: Variables
    
    private var viewModel: HomeViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<CollectionSection, CollectionItem>
    private lazy var dataSource: DataSource = createDataSource()
    
    private(set) lazy var collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: createLayout()))
    
    // MARK: Actions
    
    let didSelectItem = PassthroughSubject<IndexPath, Never>()
    let didTapSeeAllForSection = PassthroughSubject<CollectionSection, Never>()

    // MARK: Lifecycle
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not supported")
    }
    
    /// Reload collectionView with a data from viewModel
    func updateDataSnapshot() {
        dataSource.apply(viewModel.dataSnapshot)
    }
}

// MARK: - Setup UI

extension HomeViewController {
    
    private func commonInit() {
        setupCommonUI()
        updateDataSnapshot()
        setupNoNetworkView()
        setupCollectionView()
        
        viewModel
            .$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateDataSnapshot()
            }
            .store(in: &cancellables)
        
        followNetworkStatusUpdates(
            onConnected: { [weak self] in
                // Reload data from scratch again
                self?.viewModel.loadData()
            },
            onNotConnected: { },
            viewToDisplayWhenConnected: collectionView
        )
    }
    
    private func setupCommonUI() {
        view.backgroundColor = UIColor(named: "Background")
        
        let titles: [String] = [
            "Your pocket cat finder 🔎",
            "Find your cutie asap 💖",
            "🐈 Calico the App 🐈",
            "🐾 Dirty paws are everywhere 🐾"
        ]

        navigationItem.title = titles.shuffled().randomElement()
    }
    
    private func setupCollectionView() {
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier
        )
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        if !NetworkMonitor.shared.isConnected {
            collectionView.isHidden = true
        }
    }
}

// MARK: - UICollectionView delegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.send(indexPath)
    }
}

// MARK: - UICollectionView layout & dataSource

extension HomeViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _) -> NSCollectionLayoutSection? in
            guard let strongSelf = self else { return nil }
            
            let sectionType = strongSelf.viewModel.data[sectionIndex].section.type
            switch sectionType {
                case .banner:
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(1.0)
                        )
                    )
                    
                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(strongSelf.viewModel.data[sectionIndex].sectionHeight)
                        ),
                        subitems: [item]
                    )
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .paging
                    return section
                    
                case .square, .wideWithOverlay:
                    // Predefined horizontal distance between items in the slider section
                    let interGroupSpacing: CGFloat = 8.0
                    
                    // Setup single item size
                    let itemSize: CGSize = strongSelf.viewModel.data[sectionIndex].itemSize
                    let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .absolute(itemSize.width),
                            heightDimension: .absolute(itemSize.height)
                        )
                    )
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                    
                    // Setup item container size
                    let numberOfItemsInSection = strongSelf.viewModel.data[sectionIndex].items.count

                    let itemsOnlyWidth: CGFloat = CGFloat(numberOfItemsInSection) * itemSize.width
                    let itemsSpacingWidth: CGFloat = (CGFloat(numberOfItemsInSection) - 1) * interGroupSpacing
                    let estimatedSectionWidth = itemsOnlyWidth + itemsSpacingWidth
                    
                    let sectionHeight: CGFloat = strongSelf.viewModel.data[sectionIndex].sectionHeight
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .estimated(estimatedSectionWidth),
                            heightDimension: .absolute(sectionHeight)
                        ),
                        subitems: [item]
                    )
                    
                    // Setup section header
                    let headerSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(50)
                    )
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: headerSize,
                        elementKind: TitleCollectionHeaderSwiftUIView.elementKind,
                        alignment: .topLeading
                    )
                    
                    // Create a section
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [sectionHeader]
                    section.interGroupSpacing = interGroupSpacing
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                    
                    return section
            }
        }
        
        return layout
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, itemModel) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(indexPath) as ImageCollectionViewCell
                cell.config(with: itemModel)
                
                return cell
            }
        )
        
        /* Setup section headers */
        
        // Register a custom section header based on SwiftUI View
        let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewCell>
            .init(elementKind: TitleCollectionHeaderSwiftUIView.elementKind) { [weak self] supplementaryView, elementKind, indexPath in
                // Return empty view in case self is deallocated
                guard let displayItem = self?.viewModel.data[indexPath.section] else {
                    supplementaryView.contentConfiguration = UIHostingConfiguration {
                        EmptyView()
                    }
                    return
                }
                
                supplementaryView.contentConfiguration = UIHostingConfiguration {
                    TitleCollectionHeaderSwiftUIView(
                        title: displayItem.sectionHeader,
                        description: displayItem.sectionDescription,
                        displaySeeAllButton: displayItem.section.type == .square,
                        seeAllButtonDidTap: { [weak self] in
                            self?.didTapSeeAllForSection.send(displayItem.section)
                        }
                    )
                }
            }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: sectionHeaderRegistration,
                for: indexPath
            )
        }
        
        return dataSource
    }
}

// MARK: - UICollectionView Prefetching

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { (indexPath: IndexPath) in
            return viewModel.data[indexPath.section].items[indexPath.item].imageURL
        }
        ImagePrefetcher(urls: urls).start()
    }
}
