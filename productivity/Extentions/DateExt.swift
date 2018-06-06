//
//  DateExt.swift
//  productivity
//
//  Created by MoHapX on 04.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation

extension NSDate {
    var startOfDay: NSDate {
        return NSCalendar.current.startOfDay(for: NSDate() as Date) as NSDate
    }
    
    var endOfDay: NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.current.date(byAdding: components as DateComponents, to: Date())! as NSDate
    }
}

extension Date {
    
    func startOfDay(date: Date) -> Date {
        return NSCalendar.current.startOfDay(for: date) as Date
    }
    
    func endOfDay(date: Date) -> Date {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.current.date(byAdding: components as DateComponents, to: date)! as Date
    }
    
    func startOfMonth() -> Date? {
        
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents)
        
        return startOfMonth
    }
    
    func startOfWeek() -> Date? {
        
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let currentDateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        var startOfWeek = calendar.date(from: currentDateComponents)
        
        // т.к возвращаемое значение равно воскресенью, то мы добавляем 1 день
//        startOfWeek?.addTimeInterval(86400)
        
        return startOfWeek
    }
    
    func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = monthsToAdd
        
        return calendar.date(byAdding: months, to: self)
    }
    
    func endOfMonth() -> Date? {
        
        guard let plusOneMonthDate = dateByAddingMonths(1) else { return nil }
        
        let calendar = Calendar.current
        let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
        
        return endOfMonth
        
    }
    
    func currentMonthName() -> String {
        let now = localDate()?.startOfMonth()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let nameOfMonth = dateFormatter.string(from: now!)
        
        return nameOfMonth
    }
    
  
    func currentDayOfMonth() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayOfMonth = dateFormatter.string(from: Date())
        

        
        return dayOfMonth
    }
    
    func currentDayOfWeek() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: Date())
    }
    
    func dayOfWeekShortName(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
                
        return dateFormatter.string(from: date)
    }
    
    func localDate() -> Date? {
        
        let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: Date()))
            
        return Date().addingTimeInterval(localOffeset)
    }
    
    
}
