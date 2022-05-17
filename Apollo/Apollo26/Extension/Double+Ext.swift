//
//  Double+Ext.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/15.
//

import Foundation

extension Double {
    func round2() -> Double {
        return ceil(self * 100) / 100
    }
    func round4() -> Double {
        return ceil(self * 1000000) / 1000000
    }
    
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
