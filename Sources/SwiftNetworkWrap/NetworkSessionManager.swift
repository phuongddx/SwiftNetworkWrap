//
//  NetworkSessionManager.swift
//
//
//  Created by PhuongDoan on 21/6/24.
//

import Foundation
import Combine

public protocol NetworkSessionManager {
    var session: URLSession { get }
    var baseURL: String { get }
    var bgQueue: DispatchQueue { get }
}

public extension NetworkSessionManager {
    func call<Response: Decodable>(_ target: ApiTarget,
                                   httpCodes: HTTPCodes = .success) -> AnyPublisher<Response, Error> {
        do {
            let request = try target.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch {
            return Fail<Response, Error>(error: error)
                .eraseToAnyPublisher()
        }
    }
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestData(httpCodes: HTTPCodes = .success) -> AnyPublisher<Data, Error> {
        return tryMap {
            assert(!Thread.isMainThread)
            guard let code = ($0.response as? HTTPURLResponse)?.statusCode else {
                throw ApiError.unexpectedResponse
            }
            guard httpCodes.contains(code) else {
                throw ApiError.httpCode(code)
            }
            return $0.data
        }
        .extractUnderlyingError()
        .eraseToAnyPublisher()
    }
}

fileprivate extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Response: Decodable>(httpCodes: HTTPCodes) -> AnyPublisher<Response, Error> {
        return requestData(httpCodes: httpCodes)
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// - MARK: Example Usage

public final class DefaultNetworkSessionManager: NetworkSessionManager {
    public var baseURL: String
    public var session: URLSession
    public var bgQueue: DispatchQueue

    public init(baseURL: String,
         session: URLSession = URLSession.configuredURLSession(),
         bgQueue: DispatchQueue = DispatchQueue(label: "bg_parse_queue")) {
        self.baseURL = baseURL
        self.session = session
        self.bgQueue = bgQueue
    }
}

extension URLSession {
    public static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
}
