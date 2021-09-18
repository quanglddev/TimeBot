//
//  SetNotificationHelper.swift
//  TimeBot
//
//  Created by QUANG on 4/2/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UserNotifications
import Dotzu

extension HomeVC {
    
    func setNotificationForWeek() {
        
        DispatchQueue.global(qos: .background).async {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            let areAllMissions = self.userDefaults.bool(forKey: defaultsKeys.areAllBeAlert)
            
            //let today = getDayOfWeek()
            
            let countNoti = self.userDefaults.integer(forKey: defaultsKeys.countNoti)
            
            for i in 0..<self.weekCollection.count {
                for j in 0..<self.weekCollection[i].count {
                    
                    if areAllMissions || self.weekCollection[i][j].prioritized {
                        let content = UNMutableNotificationContent()
                        content.title = "TimeBot"
                        content.subtitle = "NOTI_SUBTITLE".localized(lang: self.language!)
                        content.body = "NOTI_BODY_1".localized(lang: self.language!) + "'\(self.weekCollection[i][j].title)'" + "NOTI_BODY_2".localized(lang: self.language!) + "\(0.hourFrom(minuteth: self.weekCollection[i][j].end))"
                        content.badge = 1
                        content.sound = UNNotificationSound.default()
                        
                        
                        let identifier = self.weekCollection[i][j].title.replacingOccurrences(of: " ", with: "") + "\(i)" + "\(j)"
                        
                        /*
                         if let image = weekTableView.screenshotOfCellAtIndexPath(indexPath: NSIndexPath(row: j, section: i)) {
                         if let attachment = try? UNNotificationAttachment(identifier: identifier, url: image , options: nil) {
                         content.attachments = [attachment]
                         }
                         }*/
                        
                        if let notifyDate = self.getNotifyDate(start: self.weekCollection[i][j].start, weekDay: i) {
                            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notifyDate)
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                            
                            let requestIdentifier = identifier
                            
                            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                                if error != nil {
                                    Logger.error("Uh oh! We had an error: \(error) with task: \(self.weekCollection[i][j].title)")
                                }
                                else {
                                    Logger.verbose("Successfully notify \(self.weekCollection[i][j].title)")
                                    self.userDefaults.set(countNoti + 1, forKey: defaultsKeys.countNoti)
                                    
                                    self.userDefaults.synchronize()
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func getNotifyDate(start: Int, weekDay: Int) -> Date? {
        
        let before = 900 //15 minutes
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let hours = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        
        var secondToTriggerStart = (start * 5 * 60) - (hours * 3600 + minutes * 60 + seconds)
        
        secondToTriggerStart += (weekDay * 86400)
        
        secondToTriggerStart -= before

        if secondToTriggerStart > 0 {
            return Date(timeIntervalSinceNow: TimeInterval(secondToTriggerStart))
        }
        
        return nil
    }
}
