//
//  Coin.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/10.
//

import Foundation

struct ProductOhlc {
    var timestamp: Double
    var open: Double
    var high: Double
    var low: Double
    var close: Double
}

struct Product {
    var id: String = ""
    var type: String = ProductType.coin.rawValue
    var symbol: String = ""
    var name: String = ""
    var price: Double = 0.0
    var percent: Double = 0.0
    var imageUrl: String = ""
}
