//
//  HomeViewController.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import Foundation
import UIKit
import SwiftUI

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel
    
    typealias DataSource = UICollectionViewDiffableDataSource<HomeViewModel.CollectionSection, HomeViewModel.CollectionItem>
    private lazy var dataSource: DataSource = createDataSource()
    
    private lazy var collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: createLayout()))

    override func viewDidLoad() {
        viewModel = HomeViewModel()
        super.viewDidLoad()
        commonInit()
    }
    
    required init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not supported")
    }
    
    private func commonInit() {
        dataSource.apply(viewModel.dataSnapshot)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier
        )
        
        collectionView.dataSource = dataSource
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionView layout & dataSource

extension HomeViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _) -> NSCollectionLayoutSection? in
            guard let strongSelf = self else { return nil }
            
            switch sectionIndex {
                case 0:
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
                    return section
                    
                default:
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
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
                    
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
                cell.config(with: itemModel.imageURLString)
                cell.backgroundColor = [UIColor.yellow, UIColor.purple, UIColor.green].randomElement()
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
                        description: displayItem.sectionDescription
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
