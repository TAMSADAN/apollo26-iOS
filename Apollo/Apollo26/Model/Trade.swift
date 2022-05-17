//
//  Trade.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/12.
//

import Foundation

struct Trade {
    var id: Int = -1
    var productType: String = ProductType.coin.rawValue
    var name: String = "bitcoin"
    var symbol: String = "BTC"
    var price: Double = 0.0
    var count: Double = 0.0
    var favorite: Bool = false
    var imageSrc: String = ""
}
