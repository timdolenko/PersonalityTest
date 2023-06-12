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
