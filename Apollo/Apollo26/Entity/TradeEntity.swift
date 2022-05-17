//
//  TradeEntity.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/12.
//

import Foundation
import RealmSwift

class TradeEntity: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var productType: String = ProductType.coin.rawValue
    @objc dynamic var name: String = "bitcoin"
    @objc dynamic var symbol: String = "BTC"
    @objc dynamic var price: Double = 0.0
    @objc dynamic var count: Double = 0.0
    @objc dynamic var favorite: Bool = false
    @objc dynamic var imageSrc: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, productType: String, name: String, unit: String, price: Double, count: Double, favorite: Bool, imageSrc: String) {
        self.init()
        self.id = id
        self.productType = productType
        self.symbol = unit
        self.name = name
        self.price = price
        self.count = count
        self.favorite = favorite
        self.imageSrc = imageSrc
    }
}


