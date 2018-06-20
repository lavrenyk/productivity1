//
//  Counter.swift
//  productivity
//
//  Created by MoHapX on 31.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation

class Counter {
    
    var counterTime: Int = 0
    var counterStartTime: Date?
    var timer = Timer()
    
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(upadateTimer), userInfo: nil, repeats: true)
        counterStartTime = Date()
    }
    
    func render(tenMin: UILabel, min: UILabel, tenSec: UILabel, sec: UILabel) {
        
    }
    
    @objc func upadateTimer() -> Array<String> {
        
        var tenMin: String = ""
        var min: String = ""
        var tenSec: String = ""
        var sec: String = ""

        
        if counterTime > 0 {
            counterTime -= 1
            tenMin = "\(counterTime / 60 / 10 % 6)"
            min = "\(counterTime / 60 % 10)"
            tenSec = "\(counterTime / 10 % 6)"
            sec = "\(counterTime % 10)"
        } else {
            
            let workSession = WorkSession()
            workSession.start = counterStartTime
            workSession.end = Date()
            UserDataService.instance.saveFinishedWorkSession(workSeesion: workSession)
            
        }
        
        return [tenMin, min, tenSec, sec]
        
    }
    
    
}
