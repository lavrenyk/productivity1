//
//  TimerService.swift
//  productivity
//
//  Created by MoHapX on 28.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation

class TimerService {
    
    static let instance = TimerService()
    
    public private(set) var mainTimer: Int = 30
    public private(set) var startTime: Date?
    
    func setMainTimer(time on: Int) {
        mainTimer = on
    }
    
    func setStartTime() {
        startTime = Date()
    }
    
    
   
    
    
    
}
