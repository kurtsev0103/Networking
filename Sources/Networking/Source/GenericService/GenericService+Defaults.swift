//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public extension GenericService {
    
    var baseURL: URL {
        let environment = NetworkingFramework.networkProvider.environment
        guard let url = URL(string: environment.serverAddress) else {
            fatalError("BaseURL cannot be nil")
        }
        return url
    }
    
    var task: HTTPTask {
        if let input = input {
            if includeParametersInURL {
                return .requestParameters(type: .url(input: input))
            } else {
                return .requestParameters(type: .body(input: input))
            }
        } else {
            return .request
        }
    }
    
    var tokenType: APIToken { .main }
    
    var headers: HTTPHeaders? { nil }
        
    var input: Encodable? { nil }
    
    var includeParametersInURL: Bool { false }
    
    var stub: APIStub { .none }
    
    var encoder: JSONEncoder {
        NetworkingFramework.networkProvider.defaultEncoder
    }
    
    var decoder: JSONDecoder {
        NetworkingFramework.networkProvider.defaultDecoder
    }
    
    func request(completion: @escaping (Result<OutputResponseType, GenericErrorOutput>) -> Void) -> Cancellable {
        Network.provider.request(self, completion: completion)
    }
}
