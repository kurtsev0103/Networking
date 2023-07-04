//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

final class ExampleNetworkProvider: NetworkProviderProtocol {
    
    var environment: NetworkEnvironment = ExampleAPIEnvironment()
    var defaultTokenType: APIToken = .main
    var extraHeaders: HTTPHeaders? = nil
    
    lazy var defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .deferredToDate
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    lazy var defaultEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .deferredToDate
        encoder.keyEncodingStrategy = .useDefaultKeys
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
}
