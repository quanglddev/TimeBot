//
//  DateHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/15/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//


extension HomeVC {
    
    func scrollToToday() {
        
        var missionIndex = 0
        //Find current task
        if weekCollection[safe: getDayOfWeek()] != nil {
            let date = NSDate()
            let calendar = NSCalendar.current
            let hours = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            
            let current = ((hours * 60) + minutes) / 5
            
            for i in 0..<weekCollection[getDayOfWeek()].count {
                if weekCollection[getDayOfWeek()][i].start <= current && weekCollection[getDayOfWeek()][i].end >= current {
                    missionIndex = i
                    break
                }
                
                if weekCollection[getDayOfWeek()][i].start < current {
                    missionIndex = i
                }
            }
        }
        
        let indexPath = IndexPath(row: missionIndex, section: getDayOfWeek())
        
        if weekCollection[safe: getDayOfWeek()] != nil {
            if getDayOfWeek() == 0 {
                return
            }
            if weekCollection[getDayOfWeek()][safe: 0] != nil {
                weekTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
    }
    
    func getDayOfWeek() -> Int {
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.chinese)
        let myComponents = myCalendar?.components(.weekday, from: todayDate)
        let weekDay = myComponents?.weekday
        
        switch weekDay! {
        case 1:
            return 6
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return 2
        case 5:
            return 3
        case 6:
            return 4
        case 7:
            return 5
        default:
            return 0
        }
    }
}
