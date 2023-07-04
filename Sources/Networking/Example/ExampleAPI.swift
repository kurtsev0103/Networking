//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

struct ExampleAPI {
    
    struct ServerV1: APIEndpoint {
        var path: String = "/server/v1"
    }
    
    static var serverV1: ServerV1 {
        ServerV1()
    }
}
