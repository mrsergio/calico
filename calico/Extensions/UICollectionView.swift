//
//  UICollectionView.swift
//  calico
//
//  Created by Sergii Simakhin on 11/12/22.
//

import UIKit

extension UICollectionView {
    
    public func dequeueReusableCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
