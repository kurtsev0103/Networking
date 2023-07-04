//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

struct JSONParameterEncoder: ParameterEncoder {
        
    let encoder: JSONEncoder
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    func encode(request: inout URLRequest, input: Encodable) throws {
        let jsonData = try input.asData(encoder: encoder)
        request.setContentTypeHeaderFieldForJSON()
        request.httpBody = jsonData
    }
}
