//
//  GoldRepository.swift
//  Apollo26
//
//  Created by 송영모 on 2022/05/18.
//

import Foundation
import Alamofire

class GoldRepository {
    func getGold() {
        let url = Secret.Url.goldAPI
        let body: Parameters = [
            "vs_currency": "krw",
            "per_page": 250
        ]
        
        AF
            .request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    do {
                        Log(value)
//                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                        let coinEntities = try JSONDecoder().decode([CoingeckoEntity].self, from: data)
//                        completion(coinEntities)
                    } catch {
                        Log("JSON Parsing Error \(error)")
                    }
                    
                case .failure(let error):
                    Log("response Error \(error)")
                    break
                }
            })
    }
}
