//
//  NetworkSessionManagerMock.swift
//  NetworkingTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

import Foundation
@testable import Networking

struct NetworkTaskMock: NetworkCancellable {
    func cancel() {}
}

struct NetworkSessionManagerMock: NetworkSessionManagerProtocol {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data,response,error)
        return NetworkTaskMock()
    }
}
