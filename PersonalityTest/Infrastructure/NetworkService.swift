////
////  NetworkService.swift
////  PersonalityTest
////
////  Created by Tymofii Dolenko on 07.04.2020.
////
//
//import Foundation
//
//public enum NetworkError: Error {
//    case error(statusCode: Int, data: Data?)
//    case notConnected
//    case cancelled
//    case generic(Error)
//    case urlGeneration
//}
//
//public protocol NetworkCancellable {
//    func cancel()
//}
//
//extension URLSessionTask: NetworkCancellable {}
//
//public protocol NetworkService {
//    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
//    
//    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
//}
//
//public protocol NetworkSessionManager {
//    typealias CompletionHandler = (Data?, URLResponse?, NetworkError?) -> Void
//    
//    func request(_ request: URLRequest,
//                 completion: @escaping CompletionHandler) -> NetworkCancellable
//}
//
//public final class DefaultNetworkService {
//
//    private let config: NetworkConfigurable
//    private let sessionManager: NetworkSessionManager
//    
//    public init(config: NetworkConfigurable,
//                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager()) {
//        self.sessionManager = sessionManager
//        self.config = config
//    }
//    
//    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
//        
//        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
//            
//            if let requestError = requestError {
//                var error: NetworkError
//                if let response = response as? HTTPURLResponse {
//                    error = .error(statusCode: response.statusCode, data: data)
//                } else {
//                    error = self.resolve(error: requestError)
//                }
//                
////                self.logger.log(error: error)
//                completion(.failure(error))
//            } else {
//                self.logger.log(responseData: data, response: response)
//                completion(.success(data))
//            }
//        }
//    
////        logger.log(request: request)
//
//        return sessionDataTask
//    }
//    
//    private func resolve(error: Error) -> NetworkError {
//        let code = URLError.Code(rawValue: (error as NSError).code)
//        switch code {
//        case .notConnectedToInternet: return .notConnected
//        case .cancelled: return .cancelled
//        default: return .generic(error)
//        }
//    }
//}
//
//extension DefaultNetworkService: NetworkService {
//    
//    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
//        do {
//            let urlRequest = try endpoint.urlRequest(with: config)
//            return request(request: urlRequest, completion: completion)
//        } catch {
//            completion(.failure(.urlGeneration))
//            return nil
//        }
//    }
//}
//
//public class DefaultNetworkSessionManager: NetworkSessionManager {
//    public init() {}
//    public func request(_ request: URLRequest,
//                        completion: @escaping CompletionHandler) -> NetworkCancellable {
//        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
//        task.resume()
//        return task
//    }
//}
