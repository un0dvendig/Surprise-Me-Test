//
//  URLRequestBuilder.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 06.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//

import Foundation

/// Builder class that helps to build proper URLRequests.
class URLRequestBuilder {
    
    // MARK: - Properties
    
    private var request: URLRequest
    
    // MARK: - Initialization
    
    init(url: URL) {
        self.request = URLRequest(url: url)
    }
    
    // MARK: - Methods
    
    func setValue(_ value: String?, forHttpHeaderField httpHeaderField: String) -> URLRequestBuilder {
        self.request.setValue(value, forHTTPHeaderField: httpHeaderField)
        return self
    }
    
    func set(httpMethod: String) -> URLRequestBuilder {
        self.request.httpMethod = httpMethod
        return self
    }
    
    func set(parameters: [String: Any]) -> URLRequestBuilder {
        self.request.httpBody = parameters.percentEncoded()
        return self
    }
    
    func build() -> URLRequest {
        return self.request
    }
}
