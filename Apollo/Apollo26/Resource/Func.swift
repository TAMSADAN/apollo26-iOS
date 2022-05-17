//
//  Func.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import Foundation

public func Log<T>(_ object: T?, filename: String = #file, line: Int = #line, funcName: String = #function) {
    #if DEBUG
    if let obj = object {
        print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : \(obj)")
    } else {
        print("\(Date()) \(filename.components(separatedBy: "/").last ?? "")(\(line)) : \(funcName) : nil")
    }
    #endif
}
