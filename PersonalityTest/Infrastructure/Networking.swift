//
//  Networking.swift
//  PersonalityTest
//
//  Created by Tymofii Dolenko on 07.04.2020.
//

import Foundation

enum ApiResourceError: Error {
    case components
    case url
}

protocol ApiResource {
    associatedtype ModelType: Decodable
    var path: String { get }
}

extension ApiResource {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.basePath
        
        guard var components = URLComponents(string: baseURL) else {
            throw ApiResourceError.components
        }
        
        components.path = path
        
        guard let url = components.url else {
            throw ApiResourceError.url
        }
        
        return url
    }
}

struct QuestionsResource: ApiResource {
    typealias ModelType = QuestionsResponseDTO
    let path = "/personality_test.json"
}

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        let task = session.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            
            completion(self?.decode(data))
        }
        task.resume()
    }
}

class ApiRequest<Resource: ApiResource> {
    let resource: Resource
    let config: NetworkConfigurable
    
    init(resource: Resource, config: NetworkConfigurable) {
        self.resource = resource
        self.config = config
    }
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.ModelType? {
        try? JSONDecoder().decode(Resource.ModelType.self, from: data)
    }
    
    func load(withCompletion completion: @escaping (Resource.ModelType?) -> Void) {
        load(try! resource.url(with: config), withCompletion: completion)
    }
}

extension URL {
    var basePath: String {
        absoluteString.last != "/" ? absoluteString + "/" : absoluteString
    }
}

let questionRequest = ApiRequest(resource: QuestionsResource(), config: ApiDataNetworkConfig(baseURL: URL(string: AppConfiguration().apiBaseURL)!))
func fetch() {
    questionRequest.load { (result) in
        if let result = result {
            let domain = try? result.mapToDomain()
            print(domain?.questions.count)
        } else {
            print("FAILED")
        }
    }
}
