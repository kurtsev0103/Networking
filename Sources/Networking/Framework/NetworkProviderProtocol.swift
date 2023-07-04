//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public protocol NetworkProviderProtocol {
    var environment: NetworkEnvironment { get }
    var extraHeaders: HTTPHeaders? { get }
    var defaultDecoder: JSONDecoder { get }
    var defaultEncoder: JSONEncoder { get }
}

public protocol NetworkEnvironment {
    var current: APIEnvironment { get }
    var serverAddress: String { get }
    var webSocketAddress: String? { get }
}

public enum APIEnvironment {
    case live
    case mocked
}
