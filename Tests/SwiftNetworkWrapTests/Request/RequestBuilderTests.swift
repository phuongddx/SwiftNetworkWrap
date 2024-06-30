//
//  RequestBuilderTests.swift
//  
//
//  Created by PhuongDoan on 30/6/24.
//

import XCTest
@testable import SwiftNetworkWrap

final class RequestBuilderTests: XCTestCase {
    var sut: RequestBuilder!

    override func setUpWithError() throws {
        
        sut = DefaultHTTPRequest(request: MockNetworkTarget())
    }

    func test_buildRequest_shouldBeURLRequest() {
        let actual = sut.buildURLRequest()
        let expected = URLRequest(url: URL(string: "https://testing.com/v2/path-value?page=2")!)
        XCTAssertEqual(actual.url?.absoluteString, expected.url?.absoluteString)
    }

    func test_path_shouldReturnCorrect() {
        XCTAssertEqual(sut.path, "path-value")
    }
}

final class MockBaseURL: BaseURLType {
    var rawValue: URL = URL(string: "https://testing.com")!
}

struct MockNetworkTarget: NetworkTarget {
    var baseURL: any SwiftNetworkWrap.BaseURLType = MockBaseURL()
    var version: SwiftNetworkWrap.VersionType = .v2
    var path: String? { "path-value" }
    var methodType: SwiftNetworkWrap.HTTPMethod = .get
    var queryParams: [String : String]? = ["page": "2"]
    var queryParamsEncoding: SwiftNetworkWrap.URLEncoding? = .default
}
