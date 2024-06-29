//
//  ApiTarget.swift
//
//
//  Created by PhuongDoan on 21/6/24.
//

import Foundation

public protocol BaseURLType {
    var rawValue: URL { get }
}

public enum VersionType {
    case none
    case v1, v2, v3
    var desc: String {
        switch self {
        case .none:
            return ""
        case .v1:
            return "/v1"
        case .v2:
            return "/v2"
        case .v3:
            return "/v3"
        }
    }
}

public enum URLEncoding: String {
    // Generally for these methods - GET, HEAD, DELETE, CONNECT, OPTIONS
    case `default`
    case percentEncoded
    // Always for POST/PUT METHOD
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}

public enum BodyEncoding: String {
    case JSON
    case xWWWFormURLEncoded = "application/x-www-form-urlencoded"
}

public protocol NetworkTarget {
    var baseURL: BaseURLType { get }
    var version: VersionType { get }
    var path: String? { get }
    var methodType: HTTPMethod { get }
    var queryParams: [String: String]? { get }
    var queryParamsEncoding: URLEncoding? { get }
    var bodyEncoding: BodyEncoding? { get }
    var parameters: [String: Any]? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
    var timeoutInterval: TimeInterval? { get }
    var headers: [String: String]? { get }
}
