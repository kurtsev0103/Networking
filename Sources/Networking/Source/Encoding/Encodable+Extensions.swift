//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public extension Encodable {
    
    func asData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(self)
    }
    
    func asJson(encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try asData(encoder: encoder)
        guard let string = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Failed to encode to JSON string", code: -1)
        }
        return string
    }
    
    func asDictionary(encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try asData(encoder: encoder)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "Failed to encode to dictionary", code: -1)
        }
        return dictionary
    }
    
    func asQueryItems(encoder: JSONEncoder = JSONEncoder()) throws -> [URLQueryItem] {
        let dictionary = try asDictionary(encoder: encoder)
        return dictionary.compactMap { key, value in
            guard let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URLQueryItem(name: key, value: encodedValue)
        }
    }
}

public extension Dictionary where Key == String, Value == Any {
    
    func asData(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let encodedDict = try reduce(into: [String: Data]()) { result, element in
            guard let encodableValue = element.value as? Encodable else {
                throw NSError(domain: "Value for key '\(element.key)' is not Encodable", code: -1)
            }
            result[element.key] = try encoder.encode(encodableValue)
        }
        return try JSONSerialization.data(withJSONObject: encodedDict, options: .prettyPrinted)
    }

    func asJson(encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try asData(encoder: encoder)
        guard let string = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Failed to encode to JSON string", code: -1)
        }
        return string
    }

    func asQueryItems() throws -> [URLQueryItem] {
        let encodedParameters = try self.flatMap { key, value -> [URLQueryItem] in
            guard let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                throw NSError(domain: "Failed to encode value for key '\(key)'", code: -1)
            }
            return [URLQueryItem(name: key, value: encodedValue)]
        }
        return encodedParameters
    }
}
