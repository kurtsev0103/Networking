//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public struct MockURLResponse {
    var statusCode: Int
    var urlString: String?
    var headers: HTTPHeaders?
}

public enum APIStub {
    case none
    case success(delay: TimeInterval, data: APIStubDataProvider)
    case failure(delay: TimeInterval, error: GenericErrorOutput)
    
    func response(_ request: URLRequest) -> MockURLResponse {
        switch self {
        case .none:
            fatalError()
        case .success:
            return MockURLResponse(
                statusCode: 200,
                urlString: request.url?.absoluteString,
                headers: request.allHTTPHeaderFields ?? [:]
            )
        case .failure(_, let error):
            return MockURLResponse(
                statusCode: error.statusCode,
                urlString: request.url?.absoluteString,
                headers: request.allHTTPHeaderFields ?? [:]
            )
        }
    }
}

public struct APIStubDataProvider {
    
    let providedData: Data
    
    public init(data: Data) {
        self.providedData = data
    }
}

public extension APIStubDataProvider {
    
    static func data(_ data: Data) -> Self {
        .init(data: data)
    }
    
    static func json(_ json: String) -> Self {
        .init(data: json.data(using: .utf8) ?? Data())
    }
    
    static func mocked(file name: String) -> Self {
        guard let bundle = NetworkingFramework.mockBundle,
              let path = bundle.path(forResource: name, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        else { fatalError() }
        return .init(data: data)
    }
}
