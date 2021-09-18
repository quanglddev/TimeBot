//
//  MinutethHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/15/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import os.log

extension Int {
    func hourFrom(minuteth: Int) -> String {        
        let totalMinute = minuteth * 5
        
        var hour: Int {
            return totalMinute / 60
        }
        
        var minute: Int {
            return totalMinute % 60
        }
        
        let result = String(format: "%02d:%02d", hour, minute)
        
        return result
    }
}
