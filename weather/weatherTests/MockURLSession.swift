//
//  MockURLSession.swift
//  WeatherTests
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation

@testable import Weather

class MockURLSession: URLSessionProtocol {
    
    var responseData: Data?
    var responseHeader: HTTPURLResponse?
    var responseError: Error?
    
    var sessionDataTask = MockURLSessionDataTask()
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping dataTaskHandler)
        -> URLSessionDataTaskProtocol {
            // Note: pass local Mocked argument here
            completionHandler(responseData, responseHeader, responseError)
            return sessionDataTask
    }
}
