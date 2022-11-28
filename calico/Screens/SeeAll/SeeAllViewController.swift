//
//  SeeAllViewController.swift
//  calico
//
//  Created by Sergii Simakhin on 11/14/22.
//

import Foundation
import UIKit
import Kingfisher
import Combine

final class SeeAllViewController: UIViewController {
    
    // MARK: Variables
    
    private var viewModel: SeeAllViewModel
    private var cancellables = Set<AnyCancellable>()
    
    typealias DataSource = UICollectionViewDiffableDataSource<CollectionSection, CollectionItem>
    private lazy var dataSource: DataSource = createDataSource()
    
    internal lazy var collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: createLayout()))
    
    // MARK: Actions
    
    let didSelectItem = PassthroughSubject<IndexPath, Never>()
    let didDisappear = PassthroughSubject<Void, Never>()
    
    // MARK: Lifecycle
    
    required init(viewModel: SeeAllViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards are not supported")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        didDisappear.send(())
    }
    
    /// Reload collectionView with a data from viewModel
    func updateDataSnapshot() {
        dataSource.apply(viewModel.dataSnapshot)
        prefetchAllImages()
    }
}

// MARK: - Setup UI

extension SeeAllViewController {
    
    private func commonInit() {
        setupCommonUI()
        updateDataSnapshot()
        setupCollectionView()
        
        viewModel
            .$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateDataSnapshot()
            }
            .store(in: &cancellables)
    }
    
    private func setupCommonUI() {
        view.backgroundColor = UIColor(named: "Background")

        navigationItem.title = "#\(viewModel.tag)"
    }
    
    private func setupCollectionView() {
        collectionView.register(
            ImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier
        )
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        // Prefetching is intentionally disabled here since we manually prefetch all the images
        
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

extension SeeAllViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem.send(indexPath)
    }
}

// MARK: - UICollectionView layout & dataSource

extension SeeAllViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _) -> NSCollectionLayoutSection? in
            // Predefined horizontal distance between items in the slider section
            let interGroupSpacing: CGFloat = 8.0
            
            // Setup single item size
            let fractionalSideSize = UIDevice.current.userInterfaceIdiom == .pad ? 0.25 : 0.5
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(fractionalSideSize),
                    heightDimension: .fractionalWidth(fractionalSideSize)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(1000)
                ),
                subitems: [item]
            )
            
            // Create a section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = interGroupSpacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            return section
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
        
        return dataSource
    }
}

// MARK: - Helpers

extension SeeAllViewController {
    
    func prefetchAllImages() {
        // Prefetch all the previews
        let previewURLs = viewModel.data.compactMap({ $0.itemsPreviewURLs }).flatMap({ $0 })
        ImagePrefetcher(urls: previewURLs).start()
        
        // Prefetch original images as well (there is a high chance user would open one)
        let originalURLs = viewModel.data.compactMap({ $0.itemsOriginalURLs }).flatMap({ $0 })
        ImagePrefetcher(urls: originalURLs).start()
    }
}
