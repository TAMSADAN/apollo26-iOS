//
//  Date+Ext.swift
//  Enaco
//
//  Created by 송영모 on 2022/05/11.
//

import Foundation

extension Date {
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: self))
        return dateFormatter.string(from: self)
    }
    
    func isEqualDay(date: Date) -> Bool {
        let c1 = self.getKstDateComponents()
        let c2 = date.getKstDateComponents()

        return c1.year! == c2.year! && c1.month! == c2.month! && c1.day! == c2.day!
    }
    
    func getKstDateComponents() -> DateComponents {
        return Calendar.current.dateComponents(in: TimeZone(abbreviation: "KST")!, from: self)
    }
}
