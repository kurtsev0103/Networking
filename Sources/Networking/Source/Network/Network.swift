//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

struct Network {
    
    static let provider: NetworkServiceProtocol = NetworkService()
    
    static var environment: NetworkEnvironment {
        NetworkingFramework.networkProvider.environment
    }
    
    static var showsLog: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}
