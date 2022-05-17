//
//  AdvRepository.swift
//  Apollo26
//
//  Created by 송영모 on 2022/05/17.
//

import Foundation
import RealmSwift

class AdRepository {
    let instance = try! Realm()
    
    func getAdEntity(date: Date) -> AdEntity? {
        if let object = instance.objects(AdEntity.self).first(where: { $0.date.isEqualDay(date: date) }) {
            return object
        } else {
            return nil
        }
    }
    
    func postAdEntity(adEntity: AdEntity) {
        if let object = instance.objects(AdEntity.self).first(where: {$0.date.isEqualDay(date: adEntity.date) }) {
            try? instance.write {
                object.count = object.count + 1
            }
            return
        }
        
        var id = 0
        if let last = instance.objects(AdEntity.self).last {
            id = last.id + 1
        }
        
        adEntity.id = id
        try? instance.write {
            self.instance.add(adEntity)
        }
    }
}

extension AdRepository {
    func parseToAdEntityFromAd(ad: Ad) -> AdEntity {
        return AdEntity(id: ad.id, count: ad.count, date: ad.date)
    }
}
