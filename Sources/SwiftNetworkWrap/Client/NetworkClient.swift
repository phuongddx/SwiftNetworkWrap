//
//  NetworkClient.swift
//
//
//  Created by PhuongDoan on 29/6/24.
//

import Foundation
import Combine

public typealias AnyPuslisherResult<M> = AnyPublisher<M, Error>

public protocol NetworkClient: AnyObject {
    /// Sends the given request.
    ///
    /// - parameter request: The request to be sent.
    /// - parameter completion: A callback to invoke when the request completed.

    var session: URLSession { get }

    @available(iOS 13.0, *)
    @discardableResult
    func perform<M: Decodable, T>(with request: RequestBuilder,
                                  decoder: JSONDecoder,
                                  scheduler: T,
                                  responseObject type: M.Type) -> AnyPublisher<M, APIError> where M: Decodable, T: Scheduler
}

public protocol Logging {
    func logRequest(request: URLRequest)
    func logResponse(response: URLResponse?, data: Data?)
}

public class LoggingManager: Logging {
    public init() { }
    public func logRequest(request: URLRequest) {
        
    }

    public func logResponse(response: URLResponse?, data: Data?) {
        
    }
}

public final class DefaultNetworkClient: NetworkClient {
    /// Initializes a new URL Session Client.
    ///s
    /// - parameter urlSession: The URLSession to use.
    ///     Default: `URLSession(configuration: .shared)`.
    ///
    public let session: URLSession
    let logging: Logging

    public init(session: URLSession = URLSession.shared,
                loggin: Logging = LoggingManager()) {
        self.session = session
        self.logging = loggin
    }

    func publisher(_ request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), APIError> {
        session.dataTaskPublisher(for: request)
            .mapError { APIError.urlError($0) }
            .map { [weak self] response -> AnyPublisher<(data: Data, response: URLResponse), APIError> in
                self?.logging.logResponse(response: response.response,
                                          data: response.data)
                guard let httpResponse = response.response as? HTTPURLResponse else {
                    return Fail(error: APIError.invalidResponse(httpStatusCode: 0))
                        .eraseToAnyPublisher()
                }

                if !httpResponse.isResponseOK {
                    let error = DefaultNetworkClient.errorType(type: httpResponse.statusCode)
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
                return Just(response)
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    public func perform<M, T>(with request: any RequestBuilder,
                              decoder: JSONDecoder,
                              scheduler: T,
                              responseObject type: M.Type) -> AnyPublisher<M, APIError> where M : Decodable, T : Scheduler {
        let urlRequest = request.buildURLRequest()
        logging.logRequest(request: urlRequest)

        return publisher(urlRequest)
            .receive(on: scheduler)
            .tryMap { result, _ -> Data in
                return result
            }
            .decode(type: type.self, decoder: decoder)
            .mapError { error in
                return error as? APIError ?? .general
            }
            .eraseToAnyPublisher()
    }
}

extension HTTPURLResponse {
    var isResponseOK: Bool {
        return (200..<299).contains(statusCode)
    }
}
