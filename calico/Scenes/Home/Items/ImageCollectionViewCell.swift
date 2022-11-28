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
    
    private let overlayView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        $0.isHidden = true
        $0.clipsToBounds = true
        
        return $0
    }(UIView(frame: .zero))
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        $0.textColor = UIColor.white
        $0.numberOfLines = 2
        $0.isHidden = true
        
        return $0
    }(UILabel(frame: .zero))
    
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
        
        contentView.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func config(with collectionItem: CollectionItem) {
        /* Setup cell UI depending on passed configuration item */

        // Round corners for all sections except `banner`
        imageView.layer.cornerRadius = collectionItem.relatedSectionType != .banner ? 16 : 0
        
        // Display dark overlay over the image for the `sliderWithOverlay` section only
        overlayView.isHidden = collectionItem.relatedSectionType != .wideWithOverlay
        overlayView.layer.cornerRadius = collectionItem.relatedSectionType == .wideWithOverlay ? 16 : 0
        
        // Display title over the image for the `sliderWithOverlay` section only
        titleLabel.isHidden = collectionItem.relatedSectionType != .wideWithOverlay
        titleLabel.text = collectionItem.tag
        
        /* Set image */
        
        guard let imageURL = collectionItem.imageURL else {
            return
        }
        
        let placeholderImage = UIImage(named: "PlaceholderImage")
        
        imageView.kf.setImage(
            with: imageURL,
            placeholder: placeholderImage,
            options: [
                .onlyLoadFirstFrame, // no need to load the whole gif
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
