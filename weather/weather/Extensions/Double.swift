//
//  Double.swift
//  Weather
//
//  Created by SteveLin on 2018/2/10.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation

extension Double {
    func toCelcius() -> Double {
        return (self - 32.0) / 1.8
    }
}
