//
//  APIError.swift
//
//
//  Created by PhuongDoan on 21/6/24.
//

import Foundation

public enum APIError: Error {
    case general
    case timeout
    case pageNotFound
    case noData
    case noNetwork
    case unknownError
    case serverError
    case redirection
    case clientError
    case invalidResponse(httpStatusCode: Int)
    case statusMessage(message: String)
    case decodingError(Error)
    case connectionError(Error)
    case unauthorizedClient
    case urlError(URLError)
    case httpError(HTTPURLResponse)
    case type(Error)
}

extension APIError {
    /// Description of error
    var desc: String {
        switch self {
        case .general:                    return MessageHelper.ServerError.general
        case .timeout:                    return MessageHelper.ServerError.timeOut
        case .pageNotFound:               return MessageHelper.ServerError.notFound
        case .noData:                     return MessageHelper.ServerError.notFound
        case .noNetwork:                  return MessageHelper.ServerError.noInternet
        case .unknownError:               return MessageHelper.ServerError.general
        case .serverError:                return MessageHelper.ServerError.serverError
        case .redirection:                return MessageHelper.ServerError.redirection
        case .clientError:                return MessageHelper.ServerError.clientError
        case .invalidResponse:            return MessageHelper.ServerError.invalidResponse
        case .unauthorizedClient:         return MessageHelper.ServerError.unauthorizedClient
        case .statusMessage(let message): return message
        case .decodingError(let error):   return "Decoding Error: \(error.localizedDescription)"
        case .connectionError(let error): return "Network connection Error : \(error.localizedDescription)"
        default: return MessageHelper.ServerError.general
        }
    }
}

extension NetworkClient {
    static func errorType(type: Int) -> APIError {
        switch type {
        case 300..<400:
            return APIError.redirection
        case 400..<500:
            return APIError.clientError
        case 500..<600:
            return APIError.serverError
        default:
            return otherErrorType(type: type)
        }
    }
    private static func otherErrorType(type: Int) -> APIError {
        switch type {
        case -1001:
            return APIError.timeout
        case -1009:
            return APIError.noNetwork
        default:
            return APIError.unknownError
        }
    }
}

struct MessageHelper {
    /// General Message Handler
    struct ServerError {
        static let general: String = "Bad Request"
        static let noInternet: String = "Check the Connection"
        static let timeOut: String = "Timeout"
        static let notFound: String = "No Result"
        static let serverError: String = "Internal Server Error"
        static let redirection: String = "Request doesn't seem to be proper."
        static let clientError: String = "Request doesn't seem to be proper."
        static let invalidResponse: String = "Invalid Server Response"
        static let unauthorizedClient: String = "Unauthorized Client"
    }
    struct DeviceStatus {
        static let unknownDeviceID: String = "Device ID Not Found"
    }
}
