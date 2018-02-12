//
//  FileManager.swift
//  Weather
//
//  Created by SteveLin on 2018/2/12.
//  Copyright © 2018年 alin. All rights reserved.
//

import Foundation

extension FileManager {
    static var documentsDir: URL {
        return FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)[0]
    }
}
