//
//  DefaultHTTPRequest.swift
//
//
//  Created by PhuongDoan on 29/6/24.
//

import Foundation

public struct DefaultHTTPRequest: RequestBuilder {
    public var baseURL: any BaseURLType
    public var version: VersionType
    public var path: String?
    public var methodType: HTTPMethod
    public var queryParams: [String: String]?
    public var queryParamsEncoding: URLEncoding? = .default

    public init(request: any NetworkTarget) {
        self.baseURL = request.baseURL
        self.version = request.version
        self.path = request.path
        self.methodType = request.methodType
        self.queryParams = request.queryParams
    }
}
