//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

struct URLParameterEncoder: ParameterEncoder {
    
    let encoder: JSONEncoder
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    func encode(request: inout URLRequest, input: Encodable) throws {
        guard let url = request.url else { throw GenericErrorOutput.invalidURL }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = try input.asQueryItems(encoder: encoder)
            request.setContentTypeHeaderFieldForURL()
            request.url = urlComponents.url
        }
    }
}
