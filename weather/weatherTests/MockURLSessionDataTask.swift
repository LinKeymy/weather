//
//  MockURLSessionDataTask.swift
//  WeatherTests
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation

@testable import Weather

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    // private (set) means the property's set method is private,can only be access by interior
    private (set) var isResumeCalled = false
    
    func resume() {
        self.isResumeCalled = true
    }
}
