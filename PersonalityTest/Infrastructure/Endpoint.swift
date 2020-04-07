//
//  Endpoint.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

public enum HTTPMethodType: String {
    case get
    case post
    
    var string: String {
        self.rawValue.uppercased()
    }
}

public class Endpoint<R>: ResponseRequestable {
    
    public typealias Response = R
    public var path: String
    public var method: HTTPMethodType
    public var bodyParameters: Encodable? = nil
    public var responseDecoder: ResponseDecoder
    
    public init(path: String,
         method: HTTPMethodType,
         bodyParameters: Encodable? = nil,
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.path = path
        self.method = method
        self.bodyParameters = bodyParameters
        self.responseDecoder = responseDecoder
    }
}

public protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var bodyParameters: Encodable? { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

public protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    
    public func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.basePath
        
        guard var components = URLComponents(string: baseURL) else {
            throw RequestGenerationError.components
        }
        
        components.path = path
        
        guard let url = components.url else { throw RequestGenerationError.components }
        
        return url
    }
    
    public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.string
        
        if let body = try? bodyParameters?.toDictionary() {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return urlRequest
    }
}

extension URL {
    var basePath: String {
        absoluteString.last != "/" ? absoluteString + "/" : absoluteString
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String : Any]
    }
}
