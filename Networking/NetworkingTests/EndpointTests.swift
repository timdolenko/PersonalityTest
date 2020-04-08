//
//  EndpointTests.swift
//  NetworkingTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

import XCTest
@testable import Networking

class EndpointTests: XCTestCase {

    private let mockConfig = NetworkConfigurableMock()
    
    func test_whenRequestWithBody_shouldAddContentTypeHeader() {
        //given
        var sut = EndpointMock(path: "/test", method: .post)
        sut.bodyParameters = [
            "mock": "data"
        ]
        //when
        guard let request = try? sut.urlRequest(with: mockConfig) else {
            XCTFail("Should not happen")
            return
        }
        
        //then
        let contentTypeHeader = request.value(forHTTPHeaderField: "Content-Type")
        
        XCTAssertEqual(contentTypeHeader, "application/json")
    }
}
