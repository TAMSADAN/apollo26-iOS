//
//  TradeService.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/12.
//

import Foundation

class TradeService {
    let tradeRepository = TradeRepository()
    
    func getTrade(productType: String, name: String) -> Trade? {
        if let tradeEntity = tradeRepository.getTradeEntity(productType: productType, name: name) {
            return parseToTradeFromTradeEntity(tradeEntity: tradeEntity)
        } else {
            return nil
        }
    }
    
    func getTrades() -> [Trade] {
        let tradeEntities = tradeRepository.getTradeEntities()
        var trades: [Trade] = []
        
        for tradeEntity in tradeEntities {
            trades.append(parseToTradeFromTradeEntity(tradeEntity: tradeEntity))
        }
        
        return trades
    }
    
    func postTrade(trade: Trade) {
        tradeRepository.postTradeEntity(tradeEntity: tradeRepository.parseToEntity(trade: trade))
    }
    
    func deleteRecord(productType: ProductType, name: String) {
        tradeRepository.deleteTradeEntity(productType: productType, name: name)
    }
}

extension TradeService {
    func postKRW(count: Double) {
        let tradeKRW = Trade(id: -1, productType: ProductType.krw.rawValue, name: "krw",symbol: "원" ,price: 1.0, count: count, favorite: false, imageSrc: "https://img.icons8.com/ios-filled/100/000000/won.png")
        postTrade(trade: tradeKRW)
    }
    
    func parseToTradeFromTradeEntity(tradeEntity: TradeEntity) -> Trade {
        let trade = Trade(id: tradeEntity.id,
                          productType: tradeEntity.productType,
                          name: tradeEntity.name,
                          symbol: tradeEntity.symbol,
                          price: tradeEntity.price,
                          count: tradeEntity.count,
                          favorite: tradeEntity.favorite,
                          imageSrc: tradeEntity.imageSrc)
        return trade
    }
}
