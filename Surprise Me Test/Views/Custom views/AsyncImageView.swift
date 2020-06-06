//
//  AsyncImageView.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//
//  Original source reference:
//  https://danilovdev.blogspot.com/2018/01/ios-swift-how-to-asynchronously.html
//

import UIKit

/// An UIImageView, that has capability to download images asynchronously and to cache them.
class AsyncImageView: UIImageView {
    
    // MARK: - Private properties
    
    private var imageURL: URL?
    
    // MARK: - Methods
    
    /// Loads image from the given URL using completion to inform about download completion result.
    func loadImageFrom(url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        self.imageURL = url
        self.image = nil
        
        /// Checking if there is a cached image.
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            completion(.success(()))
            return
        }
        
        if let url = imageURL {
            DownloadManager.shared.downloadData(from: url) { (result) in
                switch result {
                case .success(let data):
                    if let image = DataWorker.shared.convertDataToUIImage(data) {
                        DispatchQueue.main.async {
                            /// Saving image to the cache.
                            ImageCache.shared.save(image, forKey: url.absoluteString)
                            /// Setting downloaded image only if url is the same.
                            /// I.e. checking if it is the same UIImageView.
                            if self.imageURL == url {
                                UIView.transition(with: self,
                                                  duration: 0.3,
                                                  options: .transitionCrossDissolve,
                                                  animations: {
                                    self.image = image
                                    completion(.success(()))
                                })
                            }
                        }
                    } else {
                        let error = CustomError.cannotCreateUIImage
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

}

