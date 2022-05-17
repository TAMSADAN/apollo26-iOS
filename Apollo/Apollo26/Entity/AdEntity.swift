//
//  AdEntity.swift
//  Apollo26
//
//  Created by 송영모 on 2022/05/17.
//

import Foundation

import Foundation
import RealmSwift

class AdEntity: Object {
    @objc dynamic var id: Int = -1
    @objc dynamic var count: Int = 0
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, count: Int, date: Date) {
        self.init()
        self.id = id
        self.count = count
        self.date = date
    }
}


