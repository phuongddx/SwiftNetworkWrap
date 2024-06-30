//
//  NetworkClientManager.swift
//
//
//  Created by PhuongDoan on 29/6/24.
//

import Foundation
import Combine

public typealias AnyPublisherResult<M> = AnyPublisher<M, APIError>

open class NetworkClientManager<Target: RequestBuilder> {

    // The URLSession client is use to call request with URLSession Data Task Publisher
    private let clientURLSession: NetworkClient

    public init(clientURLSession: NetworkClient = DefaultNetworkClient()) {
        self.clientURLSession = clientURLSession
    }

    public func request<M: Decodable, T: Scheduler>(
        _ request: Target,
        decoder: JSONDecoder = JSONDecoder(),
        scheduler: T,
        responseObject type: M.Type
    ) -> AnyPublisherResult<M> {
        clientURLSession.perform(with: request,
                                 decoder: decoder,
                                 scheduler: scheduler,
                                 responseObject: type)
    }
}
