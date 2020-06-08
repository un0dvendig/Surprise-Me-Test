//
//  Enums.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 08.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

/// An enumeration for the available sign in layout variations.
enum SignInLayout {
    case phoneNumber
    case email
}

/// An enumeration for the sign in methods' buttons' tags.
enum SignInMethodButtonTag: Int {
    case withPhoneNumber = 1
    case withGoogle = 2
    case withApple = 3
    case withFacebook = 4
}
