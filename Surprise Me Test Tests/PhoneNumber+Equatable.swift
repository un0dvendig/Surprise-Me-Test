//
//  PhoneNumber+Equatable.swift
//  Surprise Me Test Tests
//
//  Created by Eugene Ilyin on 07.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import Foundation
@testable import Surprise_Me_Test

extension PhoneNumber: Equatable {
    
    public static func == (lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        return lhs.countryCode == rhs.countryCode
            && lhs.phoneNumber == rhs.phoneNumber
//        return lhs.fullNumber == rhs.fullNumber /// Either this check or two above
    }
    
}
