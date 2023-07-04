//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public extension Data {
    
    func decodeJSON<T: Decodable>(
        _ type: T.Type, decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        try decoder.decode(type, from: self)
    }
    
    func decodePropertyList<T: Decodable>(
        _ type: T.Type, decoder: PropertyListDecoder = PropertyListDecoder()
    ) throws -> T {
        try decoder.decode(type, from: self)
    }
}
