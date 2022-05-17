//
//  AdService.swift
//  Apollo26
//
//  Created by 송영모 on 2022/05/17.
//

import Foundation

class AdService {
    let adRepository = AdRepository()
    
    func getAd(date: Date) -> Ad? {
        if let adEntity = adRepository.getAdEntity(date: date) {
            return parseToAdFromAdEntity(adEntity: adEntity)
        } else {
            return nil
        }
    }
    
    func postAd(ad: Ad) {
        adRepository.postAdEntity(adEntity: adRepository.parseToAdEntityFromAd(ad: ad))
    }
}

extension AdService {
    func parseToAdFromAdEntity(adEntity: AdEntity) -> Ad {
        return Ad(id: adEntity.id, count: adEntity.count, date: adEntity.date)
    }
}
