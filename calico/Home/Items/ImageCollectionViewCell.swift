//
//  ImageCollectionViewCell.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import UIKit
import Kingfisher

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "PlaceholderImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        return $0
    }(UIImageView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func config(with collectionItem: HomeViewModel.CollectionItem) {
        // Setup round corners
        imageView.layer.cornerRadius = collectionItem.relatedSectionType == .slider ? 16 : 0
        
        guard let imageURL = collectionItem.imageURL else {
            return
        }
        
        let placeholderImage = UIImage(named: "PlaceholderImage")
        
        imageView.kf.setImage(
            with: imageURL,
            placeholder: placeholderImage,
            options: [
                .onlyLoadFirstFrame, // no need to load the whole gif
                .alsoPrefetchToMemory, // prefetch to memory cache (as well as to the disk)
                .retryStrategy(
                    DelayRetryStrategy(
                        maxRetryCount: 3,
                        retryInterval: .seconds(2)
                    )
                ),
                .transition(.flipFromBottom(0.25)) // a nice image appear animation
            ])
    }
    
}
