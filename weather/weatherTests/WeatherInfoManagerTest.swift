//
//  WeatherInfoManagerTest.swift
//  WeatherTests
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import XCTest

// @testable make the Weather moudle visiable in this test moudle
@testable import Weather

class WeatherInfoManagerTest: XCTestCase {
    let url = URL(string: "https://darksky.net")!
    var session: MockURLSession!
    var manager: WeatherInfoManager!
    
    
    // 每个test case 执行前都会执行这个方法先
    override func setUp() {
        super.setUp()
        self.session = MockURLSession()
        self.manager = WeatherInfoManager(baseURL: url, urlSession: session)
    }
    
    // 每个test case 执行完后都会调用一下这个方法
    override func tearDown() {
        super.tearDown()
    }
    
    func test_weatherInfoAt_starts_the_session() {
        let dataTask = MockURLSessionDataTask()
        session.sessionDataTask = dataTask
        manager.weatherInformation(
        atLatitude: 52,
        longitude: 100) { (_, _) in }
        
        // check the resume method whether be called or not
        XCTAssert(session.sessionDataTask.isResumeCalled)
    }
    
    
    // 其实下面几个test的case是检测 weatherInformation内部didFinishGettingWeatherData是处理是否OK
    // 无效请求
    func test_weatherInfo_handle_invalid_request() {
        session.responseError = NSError(
            domain: "Invalid Request",
            code: 100,
            userInfo: nil)
        var error: DataManagerError? = nil
        manager.weatherInformation(
        atLatitude: 52,
        longitude: 100) { (_, e) in
            error = e
        }
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    // 返回码非200
    func test_weatherInfo_handle_statusCode_not_equalTo_200() {
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil)
        var error: DataManagerError? = nil
        manager.weatherInformation(
            atLatitude: 50,
            longitude: 100) { (_, e) in
                    error = e
        }
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    //返回码为200，但JSON的decode失败
    func test_weatherInfo_handle_invalid_response() {
        let data = "{{".data(using: .utf8)!
        session.responseData = data
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        var error: DataManagerError? = nil
        manager.weatherInformation(
        atLatitude: 50,
        longitude: 100) { (_, e) in
            error = e
        }
        XCTAssertEqual(error, DataManagerError.invalidResponse)
    }
    
    func test_weatherInfoAt_handle_response_decode() {
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)

        let JSONString = """
        {
            "longitude" : 100,
            "latitude" : 52,
                "currently" : {
                "temperature" : 23,
                "humidity" : 0.91,
                "icon" : "snow",
                "time" : 1507180335,
                "summary" : "Light Snow"
        }
        }
        """
        let data = JSONString.data(using: .utf8)
        session.responseData = data
       
        var decoded: WeatherInfo? = nil
        manager.weatherInformation(
            atLatitude: 50,
            longitude: 100) { (d, _) in
                decoded = d
        }
        
        let expected = WeatherInfo(
            latitude: 52,
            longitude: 100,
            currently: WeatherInfo.CurrentWeather(
                time: Date(timeIntervalSince1970: 1507180335),
                summary: "Light Snow",
                icon: "snow",
                temperature: 23,
                humidity: 0.91))
        
        XCTAssertEqual(decoded, expected)
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
