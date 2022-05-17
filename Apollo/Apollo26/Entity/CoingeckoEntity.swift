//
//  CoinEntity.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import Foundation

struct CoingeckoOhlcEntity: Codable {
    var timestamp: Double
    var open: Double
    var high: Double
    var low: Double
    var close: Double
}

struct CoingeckoEntity: Codable {
    var id: String?
    var symbol: String?
    var name: String?
    var image: String?
    var current_price: Double?
    var market_cap: Double?
    var market_cap_rank: Double?
    var fully_diluted_valuation: Double?
    var total_volume: Double?
    var high_24h: Double?
    var low_24h: Double?
    var price_change_24h: Double?
    var price_change_percentage_24h: Double?
    var market_cap_change_24h: Double?
    var market_cap_change_percentage_24h: Double?
    var circulating_supply: Double?
    var total_supply: Double?
    var max_supply: Double?
    var ath: Double?
    var ath_change_percentage: Double?
    var ath_date: String?
    var atl: Double?
    var atl_change_percentage: Double?
    var atl_date: String?
    var roi: Roi?
    var last_updated: String?
}

struct Roi: Codable {
    var times: Double
    var currency: String
    var percentage: Double
}
