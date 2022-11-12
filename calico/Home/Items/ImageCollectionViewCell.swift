//
//  ImageCollectionViewCell.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    func config(with urlString: String?) {
        print("💥 ImageCollectionViewCell config: \(String(describing: urlString))")
        // TODO: assign `urlString` to imageView with Kingfisher
    }
    
}
