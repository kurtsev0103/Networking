//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

public protocol NetworkTokenProviderProtocol {
    func isValid(_ token: APIToken) -> Bool
    func bearer(_ token: APIToken) -> String?
    func refresh(_ token: APIToken, _ completion: @escaping (String?) -> Void)
}

public enum APIToken {
    case none
    case main
}
