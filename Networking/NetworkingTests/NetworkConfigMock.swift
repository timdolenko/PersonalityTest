//
//  NetworkConfigMock.swift
//  NetworkingTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

import Foundation
@testable import Networking

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.com")
    var headers: [String : String] = [:]
    var queryParameters: [String : String] = [:]
}
