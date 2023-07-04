//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

struct ExampleAPIEnvironment: NetworkEnvironment {
    
    public var current: /*Networking.*/APIEnvironment = .live
    
    public var serverAddress: String {
        switch current {
        case .live: return "https://api.live.com"
        case .mocked: return "https://api.mocked.com"
        }
    }
    
    public var webSocketAddress: String? {
        switch current {
        case .live: return "https://io.live.com"
        case .mocked: return "https://io.mocked.com"
        }
    }
}
