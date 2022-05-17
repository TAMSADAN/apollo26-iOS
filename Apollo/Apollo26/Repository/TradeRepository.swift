//
//  TradeRepository.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/12.
//

import Foundation
import RealmSwift

class TradeRepository {
    let instance = try! Realm()
    
    func getTradeEntity(productType: String, name: String) -> TradeEntity? {
        if let object = instance.objects(TradeEntity.self).first(where: {$0.productType == productType && $0.name == name}) {
            return object
        } else {
            return nil
        }
    }
    
    func getTradeEntities() -> [TradeEntity] {
        return Array(instance.objects(TradeEntity.self))
    }
    
    func postTradeEntity(tradeEntity: TradeEntity) {
        if let object = instance.objects(TradeEntity.self).first(where: {$0.productType == tradeEntity.productType && $0.name == tradeEntity.name}) {
            try? instance.write {
                object.productType = tradeEntity.productType
                object.name = tradeEntity.name
                object.symbol = tradeEntity.symbol
                object.price = (object.price * object.count + tradeEntity.price * tradeEntity.count) / (object.count + tradeEntity.count)
                object.count = (object.count + tradeEntity.count)
                object.favorite = tradeEntity.favorite
                object.imageSrc = tradeEntity.imageSrc
            }
            return
        }
        
        var id = 0
        if let last = instance.objects(TradeEntity.self).last {
            id = last.id + 1
        }
        
        tradeEntity.id = id
        try? instance.write {
            self.instance.add(tradeEntity)
        }
    }
    
    func deleteTradeEntity(productType: ProductType, name: String) {
        if let object = instance.objects(TradeEntity.self).first(where: {$0.productType == productType.rawValue && $0.name == name}) {
            try? instance.write {
                instance.delete(object)
            }
            return
        }
    }
}

extension TradeRepository {
    func parseToEntity(trade: Trade) -> TradeEntity {
        let tradeEntity = TradeEntity(id: trade.id,
                                      productType: trade.productType,
                                      name: trade.name,
                                      unit: trade.symbol,
                                      price: trade.price,
                                      count: trade.count,
                                      favorite: trade.favorite,
                                      imageSrc: trade.imageSrc)
        return tradeEntity
    }
}
