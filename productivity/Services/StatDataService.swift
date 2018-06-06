//
//  StatDataService.swift
//  productivity
//
//  Created by MoHapX on 04.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class StatDataService {
    
    static let instance = StatDataService()
    let realm = try! Realm()
    
    let day: Int = 86400
    var weekDays: [String] = []
    
    func loadWeekStat() -> Array<Int> {
        var weekStat: Array<Int> = []
        for index in 0...6 {
            let beginingOfWeekDay = Date().startOfWeek()! + Double(day * index)
            let endOfWeekDay = Date().endOfDay(date: beginingOfWeekDay)
            let dayResult = realm.objects(Task.self).filter("start > %@ && start < %@", beginingOfWeekDay, endOfWeekDay)
            
            weekStat.append(dayResult.count * 25)
        }
        
        return weekStat
    }
    
    func loadWeekDaysNames() -> [String] {
        for index in 0...6 {
            let beginingOfWeekDay = Date().startOfWeek()! + Double(day * index)
            
            weekDays.append(Date().dayOfWeekShortName(date: beginingOfWeekDay))
        }
        
        return weekDays
    }
}
