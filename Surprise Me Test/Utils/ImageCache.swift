//
//  ImageCache.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

/// A singleton object that is responsible for caching UIImage entities.
class ImageCache {
    
    // MARK: - Properties
    
    static let shared = ImageCache()
    
    // MARK: - Private properties
    
    private let cache: NSCache<NSString, UIImage>
    private var observerReference: NSObjectProtocol? /// A reference to the observer, responsible for clearing the cache.
    
    // MARK: - Initialization
    
    private init() {
        self.cache = NSCache<NSString, UIImage>()
        self.observerReference = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification, object: nil, queue: nil) { [unowned self] (notification) in
            self.cache.removeAllObjects()
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        if let observerReference = observerReference {
            NotificationCenter.default.removeObserver(observerReference)
        }
    }
    
    // MARK: - Methods
    
    /// Returns an UIImage from the cache for the given key. If no found, returns nil
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    /// Saves given UIImage to the cache using given key.
    func save(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
}

