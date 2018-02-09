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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_weatherInfoAt_starts_the_session() {
        let session = MockURLSession()
        let dataTask = MockURLSessionDataTask()
        session.sessionDataTask = dataTask
        let url = URL(string:"https://darksky.net")!
        
        let manager = WeatherInfoManager(baseURL: url, urlSession: session)
        manager.weatherInformation(atLatitude: 52, longitude: 100) { (_, _) in }
        // check the resume method whether be called or not
        XCTAssert(session.sessionDataTask.isResumeCalled)
    }
    
    func test_weatherInfo_gets_data() {
        
        let expect = expectation(description: "Loding data from \(API.authenticatedURL)")
        var data: WeatherInfo? = nil
        
        WeatherInfoManager.shared
            .weatherInformation(
            atLatitude: 52,
            longitude: 100) { (info, error) in
                data = info
                expect.fulfill()
        }
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(data)
    }
    
    // 其实下面几个test的case是检测 weatherInformation内部didFinishGettingWeatherData是处理是否OK
    // 无效请求
    func test_weatherInfo_handle_invalid_request() {
        let url = URL(string: "https://darksky.net")!
        let session = MockURLSession()
        session.responseError = NSError(
            domain: "Invalid Request",
            code: 100,
            userInfo: nil)
        var error: DataManagerError? = nil
        let manager = WeatherInfoManager(baseURL: url, urlSession: session)
        manager.weatherInformation(
        atLatitude: 52,
        longitude: 100) { (_, e) in
            error = e
        }
        XCTAssertEqual(error, DataManagerError.failedRequest)
    }
    
    // 返回码非200
    func test_weatherInfo_handle_statusCode_not_equalTo_200() {
        let url = URL(string: "https://darksky.net")!
        let session = MockURLSession()
        let data = "{}".data(using: .utf8)!
        session.responseData = data
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil)
        let manager = WeatherInfoManager(
            baseURL: url,
            urlSession: session)
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
        let url = URL(string: "https://darksky.net")!
        let session = MockURLSession()
        let data = "{{".data(using: .utf8)!
        session.responseData = data
        session.responseHeader = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil)
        let manager = WeatherInfoManager(
            baseURL: url,
            urlSession: session)
        var error: DataManagerError? = nil
        manager.weatherInformation(
        atLatitude: 50,
        longitude: 100) { (_, e) in
            error = e
        }
        XCTAssertEqual(error, DataManagerError.invalidResponse)
    }
    
    func test_weatherInfoAt_handle_response_decode() {
        let url = URL(string: "https://darksky.net")!
        let session = MockURLSession()
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
        let manager = WeatherInfoManager(
            baseURL: url,
            urlSession: session)
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
