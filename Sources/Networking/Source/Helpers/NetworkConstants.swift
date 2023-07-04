//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public enum NetworkConstants {
    
    public enum HeaderField {
        public static let authorization = "Authorization"
        public static let contentType = "Content-Type"
    }
    
    public enum ContentTypeValue {
        public static let json = "application/json"
        public static let url = "application/x-www-form-urlencoded; charset=utf-8"
    }
}
