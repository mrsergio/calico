//
//  CollectionItemShareable.swift
//  calico
//
//  Created by Sergii Simakhin on 11/15/22.
//

import UIKit
import Kingfisher

extension UIViewController {
    
    /// Share given item via iOS Share Sheet
    /// - Parameter collectionItem: item to share
    func shareItem(_ collectionItem: CollectionItem) {
        // Get non-optional original URL to use a key
        guard let originalImageURL = collectionItem.originalImageURL else {
            return
        }
        
        // Retrieve image from Kingfisher's cache, save the image to disk and launch share sheet (perform in background since it is an expensive task)
        DispatchQueue.global(qos: .userInteractive).async {
            ImageCache.default.retrieveImage(forKey: originalImageURL.absoluteString) { [weak self] result in
                switch result {
                    case .success(let cacheResult):
                        /* Save retrieved image to the temporary folder first */
                        
                        let fileURL = FileManager.default
                            .temporaryDirectory
                            .appending(path: collectionItem.id)
                            .appendingPathExtension("jpg")
                        
                        let imageData: Data? = cacheResult.image?.jpegData(compressionQuality: 0.9)
                        
                        do {
                            if !FileManager.default.fileExists(atPath: fileURL.relativePath) {
                                try imageData?.write(to: fileURL)
                            }
                        } catch {
                            print("Error writing on disk")
                            return
                        }
                        
                        /* Present share sheet */
                        DispatchQueue.main.async { [weak self] in
                            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
                            activityViewController.popoverPresentationController?.sourceView = self?.presentedViewController?.view
                            
                            if UIDevice.current.userInterfaceIdiom == .pad {
                                // iPad-related improvements to position share sheet above "Share" button
                                let parentViewSize = self?.presentedViewController?.view.bounds.size ?? UIScreen.main.bounds.size
                                activityViewController.popoverPresentationController?.sourceRect = CGRect(
                                    x: parentViewSize.width / 2,
                                    y: parentViewSize.height - 76,
                                    width: 0,
                                    height: 0
                                )
                            }
                            
                            self?.presentedViewController?.present(activityViewController, animated: true)
                        }
                        
                    case .failure(let error):
                        print("Error while retrieving an image from Kingfisher cache: \(error)")
                        return
                }
            }
        }
    }
}
