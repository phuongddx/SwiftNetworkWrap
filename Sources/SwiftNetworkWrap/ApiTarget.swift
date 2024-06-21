//
//  ApiTarget.swift
//
//
//  Created by PhuongDoan on 21/6/24.
//

import Foundation

public protocol ApiTarget {
    var path: String { get }
    var method: String { get }
    var hearders: [String: String]? { get }

    func body() throws -> Data?
}

public extension ApiTarget {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = hearders
        request.httpBody = try body()
        return request
    }
}


// Remvoe
enum MoviesApiTarget: ApiTarget {
    case trendingToday
    
    var path: String {
        ""
    }
    
    var method: String {
        "GET"
    }
    
    var hearders: [String : String]? {
        [:]
    }
    
    func body() throws -> Data? {
        nil
    }
}
