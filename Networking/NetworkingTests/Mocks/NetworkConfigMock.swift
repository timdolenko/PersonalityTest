import Foundation
@testable import Networking

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.com")!
    var headers: [String : String] = [:]
    var queryParameters: [String : String] = [:]
}
