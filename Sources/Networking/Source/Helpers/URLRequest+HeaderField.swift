//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

extension URLRequest {
    
    mutating func setContentTypeHeaderFieldForJSON() {
        setContentTypeHeaderField(NetworkConstants.ContentTypeValue.json)
    }
    
    mutating func setContentTypeHeaderFieldForURL() {
        setContentTypeHeaderField(NetworkConstants.ContentTypeValue.url)
    }
    
    mutating func setAuthorizationTokenHeaderField(bearerToken: String?) {
        guard let bearerToken = bearerToken else { return }
        let authorization = NetworkConstants.HeaderField.authorization
        setValue(bearerToken, forHTTPHeaderField: authorization)
    }
    
    private mutating func setContentTypeHeaderField(_ contentType: String) {
        let headerField = NetworkConstants.HeaderField.contentType
        guard value(forHTTPHeaderField: headerField) == nil else { return }
        setValue(contentType, forHTTPHeaderField: headerField)
    }
}
