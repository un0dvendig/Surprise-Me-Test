//
//  CustomError.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 04.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import Foundation

public enum CustomError: Error {
    case cannotBuildURL
    case cannotCreateUIImage
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
    case unknown = "Unknown error"
}
