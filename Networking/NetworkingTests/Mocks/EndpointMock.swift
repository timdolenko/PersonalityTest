//
//  EndpointMock.swift
//  NetworkingTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

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
