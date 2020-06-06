//
//  PhoneNumber.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

struct PhoneNumber {
    
    // MARK: - Properties
    
    let countryCode: String
    let phoneNumber: String
    
    // MARK: - Computed properties
    
    var fullNumber: String {
        return countryCode+phoneNumber
    }
    
}
