//
//  WeatherInfoManager.swift
//  Weather
//
//  Created by SteveLin on 2018/2/9.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation


enum InfoManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}

final class WeatherInfoManager {
    
    private let baseURL: URL
    
    private let urlSession: URLSession
    
    private init(baseURL: URL, urlSession: URLSession ) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    static let shared = WeatherInfoManager(baseURL: API.authenticatedURL,
                                           urlSession: URLSession.shared)
    
    typealias CompletionHandler = (WeatherInfo?, InfoManagerError?) -> ()
    
    func weatherInformation(atLatitude latitude:Double,
                            longitude: Double,
                            completion:@escaping CompletionHandler ) {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)
        
        request.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        self.urlSession.dataTask(
            with: request, completionHandler: {
                (data, response, error) in
                DispatchQueue.main.async {  // aack to main thread for updating UI
                    self.didFinishGettingWeatherData(
                        data: data,
                        response: response,
                        error: error,
                        completion: completion)
                }
        }).resume()
        
    }
    
    func didFinishGettingWeatherData(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: CompletionHandler) {
        if let _ = error {
            completion(nil, .failedRequest)
        }
        else if let data = data,
            let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let weatherData =
                        try JSONDecoder().decode(WeatherInfo.self, from: data)
                    completion(weatherData, nil)  // decode success
                }
                catch {  // decode failed
                    completion(nil, .invalidResponse)
                }
            }
            else {  // request failed
                completion(nil, .failedRequest)
            }
        }
        else { // unknown
            completion(nil, .unknown)
        }
    }
    
}
