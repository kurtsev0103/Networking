//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

final class NetworkStubDataTask: NetworkDataTaskType {
    
    // MARK: - Private Properties
    
    private var task: DispatchWorkItem?
    private var delay: TimeInterval = 0.0
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
    func resume() {
        guard let task = task else { fatalError() }
        DispatchQueue.main.asyncAfter(
            deadline: .now() + delay, execute: task
        )
    }
    
    func cancel() {
        task?.cancel()
    }
    
    @discardableResult
    func create<T: GenericService>(
        target: T,
        response: MockURLResponse,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) -> Self {
        switch target.stub {
        case .none:
            fatalError()
        case .success(let delay, let data):
            create(
                target: target,
                response: response,
                delay: delay,
                data: data,
                success: success,
                failure: failure
            )
        case .failure(let delay, let error):
            create(
                target: target,
                response: response,
                delay: delay,
                error: error,
                success: success,
                failure: failure
            )
        }
        
        return self
    }
    
    private func create<T: GenericService>(
        target: T,
        response: MockURLResponse,
        delay: TimeInterval,
        data: APIStubDataProvider? = nil,
        error: GenericErrorOutput? = nil,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) {
        let task = DispatchWorkItem {
            NetworkLogger.logResponse(response, data?.providedData)
            
            if let error = error {
                failure(.error(error, response.statusCode))
                return
            }
            
            guard let data = data else {
                failure(.invalidData)
                return
            }
            
            do {
                let result = try data.providedData.decodeJSON(
                    T.OutputResponseType.self, decoder: target.decoder
                )
                success(.success(result))
            } catch {
                failure(.decodingError(error.localizedDescription))
            }
        }
        
        self.task = task
        self.delay = delay
    }
    
    func create<T: GenericService>(
        target: T,
        request: URLRequest,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) -> Self {
        failure(.invalidRequest)
        return self
    }
}
