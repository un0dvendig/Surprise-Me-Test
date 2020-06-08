//
//  CustomError.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import Foundation

/// An enumeration for the custom errors.
public enum CustomError: Error {
    case cannotBuildURL
    case cannotCreateUIImage
    case cannotCreateString
    case errorWithText(String)
    case unknown
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotBuildURL:
            return ErrorText.cannotBuildURL.rawValue
        case .cannotCreateUIImage:
            return ErrorText.cannotCreateUIImage.rawValue
        case .cannotCreateString:
            return ErrorText.cannotCreateString.rawValue
        case .unknown:
            return ErrorText.unknown.rawValue
        case .errorWithText(let text):
            return text
        }
    }
}

public enum ErrorText: String {
    case cannotBuildURL = "Cannot build an URL"
    case cannotCreateUIImage = "Cannot create an UIImage"
    case cannotCreateString = "Cannot create a String"
    case unknown = "Unknown error"
}
