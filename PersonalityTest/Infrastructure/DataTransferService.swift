//
//  DataTransferService.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

public protocol DataTransferServiceProtocol {
    typealias CompletionHandler<T> = (Result<T, Error>) -> Void
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public final class DataTransferService {
    
    private let networkService: NetworkServiceProtocol
    
    public init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension DataTransferService: DataTransferServiceProtocol {
    
//    public func request<T: Decodable, E>(with endpoint: Endpoint<E>,
//                                         completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {
//        
//    }
    
}

public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() {}
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
