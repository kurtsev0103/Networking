//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

protocol ParameterEncoder {
    func encode(request: inout URLRequest, input: Encodable) throws
}

extension EncodingType {
    
    func encode(request: inout URLRequest, encoder: JSONEncoder) throws {
        switch self {
        case .url(let input):
            try URLParameterEncoder(encoder: encoder).encode(request: &request, input: input)
        case .body(let input):
            try JSONParameterEncoder(encoder: encoder).encode(request: &request, input: input)
        }
    }
}
