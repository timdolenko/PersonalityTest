import Foundation
@testable import Networking

struct EndpointMock: Requestable {
    var path: String
    var method: HTTPMethodType
    var bodyParameters: Encodable?
    
    init(path: String, method: HTTPMethodType) {
        self.path = path
        self.method = method
    }
}
