//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

// MARK: - GenericErrorOutputType

public protocol GenericErrorOutputType: Error {
    var title: String { get }
    var message: String { get }
    var statusCode: Int { get }
    var isError500: Bool { get }
    var isUnauthorizedError: Bool { get }
    var localizedDescription: String { get }
}

public enum GenericErrorOutput: GenericErrorOutputType {
    case encodingError(_ message: String)
    case decodingError(_ message: String)
    case invalidResponse(_ error: Error?, _ statusCode: Int)
    case refreshTokenFailure
    case invalidRequest
    case invalidData
    case invalidURL
    case noInternet
    case error(_ error: Error, _ statusCode: Int? = nil)
    case string(_ message: String)
}

extension GenericErrorOutput {
    
    public var title: String {
        switch self {
        case .encodingError:
            return "Encoding Error:"
        case .decodingError:
            return "Decoding Error:"
        case .invalidResponse:
            return "Response Error:"
        case .refreshTokenFailure:
            return "Refresh Token Error:"
        case .invalidRequest, .invalidData, .invalidURL, .noInternet, .error, .string:
            return "Network Error:"
        }
    }
    
    public var message: String {
        switch self {
        case .encodingError(let message):
            return message
        case .decodingError(let message):
            return message
        case .invalidResponse(let error, let statusCode):
            return "\(error?.localizedDescription ?? "Invalid response") (\(statusCode))"
        case .refreshTokenFailure:
            return "Failed to refresh token"
        case .invalidRequest:
            return "Invalid request"
        case .invalidData:
            return "Invalid data received"
        case .invalidURL:
            return "Invalid URL"
        case .noInternet:
            return "No internet connection"
        case .error(let error, _):
            return error.localizedDescription
        case .string(let message):
            return message
        }
    }
    
    public var localizedDescription: String {
        "\(title) \(message)"
    }
    
    public var statusCode: Int {
        switch self {
        case .invalidResponse(_, let statusCode):
            return statusCode
        case .error(_, let statusCode):
            return statusCode ?? -1
        default:
            return -1
        }
    }
    
    public var isError500: Bool {
        return statusCode >= 500
    }
    
    public var isUnauthorizedError: Bool {
        return statusCode == 401
    }
}
