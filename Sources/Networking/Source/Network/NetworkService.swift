//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2022 All rights reserved  //
//  ------------------------------------  //

import Foundation

typealias NetworkCompletion<T> = (Result<T, GenericErrorOutput>) -> Void

protocol NetworkServiceProtocol {
    @discardableResult
    func request<T: GenericService>(
        _ target: T,
        completion: @escaping NetworkCompletion<T.OutputResponseType>
    ) -> Cancellable
}

final class NetworkService: NetworkServiceProtocol {
    
    private var tokenRefreshAttempted = false
    
    @discardableResult
    func request<T: GenericService>(
        _ target: T,
        completion: @escaping NetworkCompletion<T.OutputResponseType>
    ) -> Cancellable {
        request(target, task: nil, completion: completion)
    }
}

extension NetworkService {
    
    @discardableResult
    private func request<T: GenericService>(
        _ target: T,
        task: NetworkDataTaskType?,
        completion: @escaping NetworkCompletion<T.OutputResponseType>
    ) -> Cancellable {
        #if DEBUG
        switch target.stub {
        case .none:
            return normalRequest(
                target: target,
                task: task ?? NetworkDataTask(),
                completion: completion
            )
        case .success, .failure:
            return stubRequest(
                target: target,
                task: task ?? NetworkStubDataTask(),
                completion: completion
            )
        }
        #else
        return normalRequest(
            target: target,
            task: task ?? NetworkDataTask(),
            completion: completion
        )
        #endif
    }
    
    private func normalRequest<T: GenericService>(
        target: T,
        task: NetworkDataTaskType,
        completion: @escaping NetworkCompletion<T.OutputResponseType>
    ) -> Cancellable {
        createRequest(target) { request in
            task.create(
                target: target,
                request: request,
                success: completion,
                failure: { [weak self] error in
                    self?.handleError(
                        target: target,
                        error: error,
                        task: task,
                        completion: completion
                    )
                }
            ).resume()
        } failure: { error in
            NetworkLogger.logError(error)
            completion(.failure(error))
        }
        return task
    }
    
    private func stubRequest<T: GenericService>(
        target: T,
        task: NetworkDataTaskType,
        completion: @escaping NetworkCompletion<T.OutputResponseType>
    ) -> Cancellable {
        createRequest(target) { request in
            let response = target.stub.response(request)
            task.create(
                target: target,
                response: response,
                success: completion,
                failure: { [weak self] error in
                    self?.handleError(
                        target: target,
                        error: error,
                        task: task,
                        completion: completion
                    )
                }
            ).resume()
        } failure: { error in
            NetworkLogger.logError(error)
            completion(.failure(error))
        }
        return task
    }
    
    private func handleError<T: GenericService>(
        target: T,
        error: GenericErrorOutput,
        task: NetworkDataTaskType,
        completion: @escaping NetworkCompletion<T.OutputResponseType>
    ) {
        NetworkLogger.logError(error)
        
        if error.isUnauthorizedError && !tokenRefreshAttempted {
            tokenRefreshAttempted = true
            
            refreshBearerToken(target: target) { [weak self] success in
                if success {
                    self?.request(target, task: task, completion: completion)
                } else {
                    NetworkLogger.logError(.refreshTokenFailure)
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(error))
        }
    }
    
    // MARK: - NetworkService + CreateRequest
    
    private func createRequest<T: GenericService>(
        _ target: T,
        success: @escaping (URLRequest) -> Void,
        failure: @escaping (GenericErrorOutput) -> Void
    ) {
        let url = target.baseURL
            .appendingPathComponent(target.endpoint.path)
            .appendingPathComponent(target.path)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = target.method.rawValue
        setupHeaders(request: &request, target: target)
        setupTask(request: &request, target: target)
        
        getBearerToken(target: target) { token in
            if let token = token {
                request.setAuthorizationTokenHeaderField(bearerToken: token)
            }
            NetworkLogger.logRequest(request)
            success(request)
        } failure: { error in
            failure(error)
        }
    }
    
    private func setupHeaders<T: GenericService>(
        request: inout URLRequest, target: T
    ) {
        if let extraHeaders = NetworkingFramework.networkProvider.extraHeaders {
            extraHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        if let headers = target.headers {
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
    }
    
    private func setupTask<T: GenericService>(
        request: inout URLRequest, target: T
    ) {
        do {
            switch target.task {
            case .request:
                break
            case .requestParameters(let type):
                try type.encode(request: &request, encoder: target.encoder)
            }
        } catch {
            NetworkLogger.logError(.encodingError(error.localizedDescription))
        }
    }
    
    private func getBearerToken<T: GenericService>(
        target: T,
        success: @escaping (String?) -> Void,
        failure: @escaping (GenericErrorOutput) -> Void
    ) {
        guard target.tokenType != .none else {
            success(nil)
            return
        }
        
        if let token = NetworkingFramework.tokenProvider.bearer(target.tokenType),
           NetworkingFramework.tokenProvider.isValid(target.tokenType) {
            success(token)
        } else {
            NetworkingFramework.tokenProvider.refresh(target.tokenType) { token in
                if let token = token {
                    success(token)
                } else {
                    failure(.refreshTokenFailure)
                }
            }
        }
    }
    
    private func refreshBearerToken<T: GenericService>(
        target: T, completion: @escaping (Bool) -> Void
    ) {
        NetworkingFramework.tokenProvider.refresh(target.tokenType) {
            completion($0 != nil)
        }
    }
}
