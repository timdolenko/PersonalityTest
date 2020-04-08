//
//  NetworkServiceTests.swift
//  NetworkingTests
//
//  Created by Tymofii Dolenko on 08.04.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

import XCTest
@testable import Networking

class NetworkServiceTests: XCTestCase {
    
    private struct EndpointMock: Requestable {
        var path: String
        var method: HTTPMethodType
        var bodyParameters: Encodable?
        
        init(path: String, method: HTTPMethodType) {
            self.path = path
            self.method = method
        }
    }
    
    private enum NetworkErrorMock: Error {
        case someError
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        let config = NetworkConfigurableMock()
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Data".data(using: .utf8)!
        
        let mock = NetworkSessionManagerMock(response: nil, data: expectedResponseData, error: nil)
        
        let sut = NetworkService(config: config, sessionManager: mock)
        
        _ = sut.request(endpoint: EndpointMock(path: "/mockPath", method: .get), completion: { (result) in
            
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedResponseData)
                expectation.fulfill()
            case .failure:
                XCTFail("Should return proper response")
            }
        })
        
        wait(for: [expectation], timeout: 0.1)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
