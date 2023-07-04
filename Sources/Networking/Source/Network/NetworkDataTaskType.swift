//  ------------------------------------  //
//      Created by Oleksandr Kurtsev      //
//  ------------------------------------  //
//          github:  kurtsev0103          //
//  ------------------------------------  //
//  Copyright © 2023 All rights reserved  //
//  ------------------------------------  //

import Foundation

protocol NetworkDataTaskType: Cancellable {
    func resume()
    func cancel()
        
    @discardableResult
    func create<T: GenericService>(
        target: T,
        request: URLRequest,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) -> Self
    
    @discardableResult
    func create<T: GenericService>(
        target: T,
        response: MockURLResponse,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) -> Self
}

extension NetworkDataTaskType {
    @discardableResult
    func create<T: GenericService>(
        target: T,
        response: MockURLResponse,
        success: @escaping NetworkCompletion<T.OutputResponseType>,
        failure: @escaping ((GenericErrorOutput) -> Void)
    ) -> Self {
        return self
    }
}
