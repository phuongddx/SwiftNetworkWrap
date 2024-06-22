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
    var headers: [String: String]? { get }

    func queryParameters() -> [String: String]?
    func body() throws -> Data?
}

public extension ApiTarget {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw ApiError.invalidUrl
        }
        urlComponents.path = path
        if let queryItems = queryParameters() {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value)}
        }
        guard let url = urlComponents.url else {
            throw ApiError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}
