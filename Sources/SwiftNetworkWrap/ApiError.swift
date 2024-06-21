//
//  ApiError.swift
//
//
//  Created by PhuongDoan on 21/6/24.
//

import Foundation

public typealias HTTPCode = Int
public typealias HTTPCodes = Range<HTTPCode>
public extension HTTPCodes {
    static let success = 200..<300
}

public enum ApiError: Error {
    case invalidUrl
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidUrl: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageDeserialization: return "Cannot deserialize image from Data"
        }
    }
}
