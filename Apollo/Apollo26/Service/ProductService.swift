//
//  CoinService.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import Foundation

class ProductService {
    let coingeckoRepository = CoingeckoRepository()
    
    func getProducts(type: ProductType = ProductType.coin, completion: @escaping ([Product]) -> Void) {
        if type == ProductType.coin {
            coingeckoRepository.getCoingeckoEntities { coingeckoEntities in
                var products: [Product] = []
                
                for coingeckoEntity in coingeckoEntities {
                    let product = self.parseToProductFromCoingeckoEntity(coingeckoEntity: coingeckoEntity)
                    products.append(product)
                }
                Log("모든 코인의 정보를 받았습니다.")
                completion(products)
            }
        }
        
    }
    
    func getCoinCharts(id: String, days: String, completion: @escaping ([ProductOhlc]) -> Void) {
        coingeckoRepository.getCoingeckoOhlcEntities(id: id, days: days) { coinChartEntities in
            var coinCharts: [ProductOhlc] = []
            
            for coinChartEntity in coinChartEntities {
                let coinChart = ProductOhlc(timestamp: coinChartEntity.timestamp,
                                          open: coinChartEntity.open,
                                          high: coinChartEntity.high,
                                          low: coinChartEntity.low,
                                          close: coinChartEntity.close)
                coinCharts.append(coinChart)
            }
            Log("\(id)의 차트를 \(days)단위로 받았습니다.")
            completion(coinCharts)
        }
    }
}

extension ProductService {
    func parseToProductFromCoingeckoEntity(coingeckoEntity: CoingeckoEntity) -> Product {
        let price = coingeckoEntity.current_price ?? 0.0
        let percent = coingeckoEntity.price_change_percentage_24h ?? 0.0
        
        let product = Product(id: coingeckoEntity.id ?? "",
                              type: ProductType.coin.rawValue,
                              symbol: coingeckoEntity.symbol ?? "",
                              name: coingeckoEntity.name ?? "",
                              price: price  + Double.random(in: -(price / 5000.0)...(price / 5000.0)),
                              percent: percent + Double.random(in: -0...0.01),
                              imageUrl: coingeckoEntity.image ?? "")
        return product
    }
}
