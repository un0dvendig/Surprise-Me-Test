//
//  DataWorker.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import UIKit

/// A singleton object that is responsible for data conversion.
class DataWorker {
    
    // MARK: - Properties
    
    static let shared = DataWorker()
    
    // MARK: - Initialization
    
    private init() { }
    
    // MARK: - Methods
    
    /// Convert given Data to UIImage. Returns optional UIImage.
    func convertDataToUIImage(_ data: Data) -> UIImage? {
        let image = UIImage(data: data)
        return image
    }
    
    /// Convert given Data to String. Returns optional String.
    func convertDataToString(_ data: Data) -> String? {
        let string = String(data: data, encoding: .utf8)
        return string
    }
    
}

