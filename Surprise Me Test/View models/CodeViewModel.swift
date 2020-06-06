//
//  CodeViewModel.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

struct CodeViewModel {
    
    // MARK: - Private properties
    
    private let user: User
    private var checkCode: String?
    
    // MARK: - Initialization
    
    init(user: User) {
        self.user = user
        self.checkCode = nil
    }
    
    // MARK: - Computed properties
    
    var userId: String {
        let stringId = String(user.id)
        return stringId
    }
    
    var userFullPhoneNumber: String? {
        guard let countyCode = user.phone?.countryCode,
            var phoneNumber = user.phone?.phoneNumber else {
            return nil
        }
        
        let end = phoneNumber.index(phoneNumber.startIndex, offsetBy: phoneNumber.count)
        let range = phoneNumber.startIndex..<end
        phoneNumber = phoneNumber.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d{2})(\\d+)", with: "($1) $2-$3-$4", options: .regularExpression, range: range)
        
        let formattedFullNumber = "\(countyCode) \(phoneNumber)"
        return formattedFullNumber
    }
    
    var currentCheckCode: String? {
        set {
            self.checkCode = newValue
        }
        get {
            return checkCode
        }
    }
    
}
