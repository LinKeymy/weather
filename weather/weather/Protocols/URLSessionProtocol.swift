//
//  URLSessionProtocol.swift
//  Weather
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation

// Use to mock URLSession
protocol URLSessionProtocol {
    typealias dataTaskHandler =
        (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping dataTaskHandler)
        -> URLSessionDataTaskProtocol
}
