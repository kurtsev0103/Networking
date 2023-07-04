//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public final class NetworkingFramework {
    
    public static var networkProvider: NetworkProviderProtocol!
    public static var tokenProvider: NetworkTokenProviderProtocol!
    public static var mockBundle: Bundle?
}
