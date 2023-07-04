//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask {
    case request
    case requestParameters(type: EncodingType)
}

public enum EncodingType {
    case url(input: Encodable)
    case body(input: Encodable)
}

public protocol APIEndpoint {
    var path: String { get }
}

public protocol TargetType: APIEndpoint {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var tokenType: APIToken { get }
}

public protocol DecodableTargetType: TargetType {
    associatedtype OutputResponseType: Decodable
}

public protocol GenericService: DecodableTargetType {
    var endpoint: APIEndpoint { get }
    var input: Encodable? { get }
    var includeParametersInURL: Bool { get }
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    var stub: APIStub { get }
    
    func request(completion: @escaping (Result<OutputResponseType, GenericErrorOutput>) -> Void) -> Cancellable
}

public protocol Cancellable {
    func cancel()
}

public struct GenericEmptyOutput: Codable {
    public init() {}
}
