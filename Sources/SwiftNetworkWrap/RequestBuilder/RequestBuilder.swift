//
//  RequestBuilder.swift
//
//
//  Created by PhuongDoan on 29/6/24.
//

import Foundation

public protocol RequestBuilder: NetworkTarget {
    init(request: NetworkTarget)
    var pathAppendedURL: URL { get }

    func setQueryTo(urlRequest: inout URLRequest,
                    urlEncoding: URLEncoding,
                    queryParams: [String: String])
    func encodedBody(bodyEncoding: BodyEncoding,
                     requestBody: [String: Any]) -> Data?
    func buildURLRequest() -> URLRequest
}
