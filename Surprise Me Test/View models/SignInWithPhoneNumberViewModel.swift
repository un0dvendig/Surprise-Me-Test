//
//  SignInWithPhoneNumberViewModel.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import Foundation

struct SignInWithPhoneNumberViewModel {
    
    // MARK: - Private properties
    
    private let user: User
    private let tour: Tour
    private let showPlace: Showplace
    
    // MARK: - Initialization
    
    init(user: User, tour: Tour, showPlace: Showplace) {
        self.user = user
        self.tour = tour
        self.showPlace = showPlace
    }
    
    // MARK: - Computed properties
    
    var userName: String {
        return user.name
    }
    
    var userPhoneNumber: PhoneNumber? {
        return user.phone
    }
    
    var userEmail: String? {
        return user.email
    }
    
    var showPlaceName: String {
        return showPlace.name
    }
    
    var showPlaceImageURL: URL? {
        if let imageURLString = showPlace.imageURLString {
            return URL(string: imageURLString)
        } else {
            /// Placeholder image url creation.
            let randomWidth = Int.random(in: 4...10) * 100
            let randomHeight = Float(randomWidth * 9 / 16)
            
            let placeholderURL = URLBuilder()
                .set(scheme: "https")
                .set(host: "source.unsplash.com")
                .set(path: "random/\(randomWidth)x\(randomHeight)")
                .build()
            return placeholderURL
        }
    }
    
    var tourName: String {
        return tour.name
    }
    
}
