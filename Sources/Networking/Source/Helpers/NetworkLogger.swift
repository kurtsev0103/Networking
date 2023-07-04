//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

public final class NetworkLogger {
    
    public static func logRequest(_ request: URLRequest) {
        guard Network.showsLog else { return }
        let method: String = request.httpMethod ?? "n/a"
        let address = request.url?.absoluteString ?? "n/a"
        let bodyData = request.httpBody ?? Data()
        let bodyString = String(data: bodyData, encoding: .utf8) ?? "n/a"
        let headerFields = request.allHTTPHeaderFields ?? [:]
        let headersString = headerFields.stringify(prefixKeys: "\t\t")
        print("\n🟡 Request: (\(method)) \(address) \r\t🔸 Headers: \(headersString)\r\t🔸 Body:\r\t\t\(bodyString)\n")
    }
    
    public static func logResponse(_ response: HTTPURLResponse, _ data: Data?) {
        guard Network.showsLog else { return }
        let statusCode = response.statusCode
        let address = response.url?.absoluteString ?? "n/a"
        let bodyData = data ?? Data()
        let bodyString = String(data: bodyData, encoding: .utf8) ?? "n/a"
        let headerFields = response.allHeaderFields as? HTTPHeaders ?? [:]
        let headersString = headerFields.stringify(prefixKeys: "\t\t")
        print("\n🟡 Response: (\(statusCode)) \(address) \r\t🔸 Headers: \(headersString)\r\t🔸 Body:\r\t\t\(bodyString)\n")
    }
    
    public static func logResponse(_ response: MockURLResponse, _ data: Data?) {
        guard Network.showsLog else { return }
        let statusCode = response.statusCode
        let address = response.urlString ?? "n/a"
        let bodyData = data ?? Data()
        let bodyString = String(data: bodyData, encoding: .utf8) ?? "n/a"
        let headersString = (response.headers ?? [:]).stringify(prefixKeys: "\t\t")
        print("\n🟡 MOCK Response: (\(statusCode)) \(address) \r\t🔸 Headers: \(headersString)\r\t🔸 Body:\r\t\t\(bodyString)\n")
    }
    
    public static func logResponse(_ response: [Any]) {
        guard Network.showsLog else { return }
        let bodyData = try? JSONSerialization.data(withJSONObject: response, options: [])
        let bodyString = String(data: bodyData ?? Data(), encoding: .utf8) ?? "n/a"
        print("\n🟡 Response: \r\t🔸 Body:\r\t\t\(bodyString)\n")
    }
    
    public static func logError(_ error: GenericErrorOutput) {
        guard Network.showsLog else { return }
        print("\n🔴 \(error.localizedDescription)\n")
    }
    
    // MARK: - Initialization
    
    private init() {}
}

// MARK: - Dictionary + Extensions

private extension Dictionary where Key == String, Value == String {
    func stringify(prefixKeys prefix: String) -> String {
        reduce("") { result, element in
            result + "\r\(prefix)\(element.0): \(element.1)"
        }
    }
}
