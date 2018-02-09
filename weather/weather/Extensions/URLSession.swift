//
//  URLSession.swift
//  Weather
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation


extension URLSession: URLSessionProtocol {
    
    typealias DataTaskHandler =
        (Data?, URLResponse?, Error?) -> Void

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping DataTaskHandler)
        -> URLSessionDataTaskProtocol {
            return (dataTask(
                with: request,
                completionHandler: completionHandler)
                as URLSessionDataTask)
                as URLSessionDataTaskProtocol
    }
}
