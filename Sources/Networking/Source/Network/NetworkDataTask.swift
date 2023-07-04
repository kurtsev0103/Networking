//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

final class NetworkDataTask: NetworkDataTaskType {
    
    // MARK: - Private Properties
    
    private let session: URLSession
    private var task: URLSessionDataTask?
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Public Methods
    
    func resume() {
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    @discardableResult
    func create<T: GenericService>(
        target: T,
        request: URLRequest,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) -> Self {
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else {
                    failure(.invalidResponse(error, -1))
                    return
                }
                
                NetworkLogger.logResponse(response, data)
                let code = response.statusCode
                
                if let error = error {
                    failure(.error(error, code))
                    return
                }
                
                guard (200..<300).contains(response.statusCode) else {
                    failure(.invalidResponse(error, code))
                    return
                }
                
                guard let data = data else {
                    failure(.invalidData)
                    return
                }
                
                do {
                    let result = try data.decodeJSON(
                        T.OutputResponseType.self, decoder: target.decoder
                    )
                    success(.success(result))
                } catch {
                    failure(.decodingError(error.localizedDescription))
                }
            }
        }
        return self
    }
}
