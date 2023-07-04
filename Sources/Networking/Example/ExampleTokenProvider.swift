//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

final class ExampleTokenProvider: NetworkTokenProviderProtocol {
    
    func isValid(_ token: APIToken) -> Bool {
        switch token {
        case .none: return false
        case .main: return true // TODO: Add token validation
        }
    }
    
    func bearer(_ token: /*Networking.*/APIToken) -> String? {
        switch token {
        case .none: return nil
        case .main: return "Bearer \("token")" // TODO: Add creating Bearer token
        }
    }
    
    func refresh(_ token: /*Networking.*/APIToken, _ completion: @escaping (String?) -> Void) {
        switch token {
        case .none: completion(nil)
        case .main: completion("new token") // TODO: Add refreshing token
        }
    }
}
