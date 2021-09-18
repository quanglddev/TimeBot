//
//  EventKitHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/22/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import EventKit


extension HomeVC {
    func setupEventKit() {
        checkCalendarAuthorizationStatus()
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            setupCalendar(completion: {_ in 
                
            })
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            print("denied")
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.setupCalendar(completion: {_ in 
                    })
                })
            } else {
                DispatchQueue.main.async(execute: {
                    //self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    func setupCalendar(completion: @escaping (_ result: String) -> ()) {
        //Creat our own calender named "TimeBot"
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        if let calendars = self.calendars {
            for i in 0..<calendars.count {
                print(calendars[i].title)
                if calendars[i].title == "TimeBot" {
                    //No need to creat if already have it
                    return
                }
            }
        }
        
        //Creat calendar
        let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        newCalendar.title = "TimeBot"
        //let sourcesInEventStore = eventStore.sources
        //newCalendar.source = sourcesInEventStore
        var destinationSource: EKSource!
        
        for source in self.eventStore.sources {
            if source.sourceType == .calDAV {
                destinationSource = source
                break
            }
            
            destinationSource = source
            
            if let destinationSource = destinationSource {
                newCalendar.source = destinationSource
            }
        }
        
        if destinationSource == nil {
            for source in self.eventStore.sources {
                if source.sourceType == .local {
                    destinationSource = source
                    break
                }
                destinationSource = source
                
                if let destinationSource = destinationSource {
                    newCalendar.source = destinationSource
                }
            }
        }
        
        if let destinationSource = destinationSource {
            newCalendar.source = destinationSource
        }
        
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaults.standard.set(newCalendar.calendarIdentifier, forKey: "TimeBotCalendar")
        } catch {
            /*
            let alert = UIAlertController(title: "Calendar could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)*/
            print("Calendar could not save", error as NSError)
        }
        
        completion("we finished!")
    }
    
    func setupEvents() {
        
        for day in weekCollection {

            
            //For every day
            for mission in day {
                //For every mission
                let totalMinuteStart = mission.start * 5
                let hourStart = totalMinuteStart / 60
                let minuteStart = totalMinuteStart % 60
                let start = initialDatePickerValue(hour: hourStart, minute: minuteStart, mission: mission)
                
                let totalMinuteEnd = mission.end * 5
                let hourEnd = totalMinuteEnd / 60
                let minuteEnd = totalMinuteEnd % 60
                let end = initialDatePickerValue(hour: hourEnd, minute: minuteEnd, mission: mission)
                
                addEvent(title: mission.title, body: mission.body, start: start, end: end, important: mission.prioritized)
            }
        }
    }
    
    func addEvent(title: String, body: String?, start: Date, end: Date, important: Bool) {
        var calendarIdentifier = ""
        
        let calendars :[EKCalendar] = self.eventStore.calendars(for: EKEntityType.event)
        for aCal in calendars
        {
            if aCal.title == "TimeBot" {
                calendarIdentifier = aCal.calendarIdentifier
                break
            }
        }
        
        let shouldAllbeAlert = userDefaults.bool(forKey: defaultsKeys.areAllBeAlert)
        
        // Use Event Store to create a new calendar instance
        if let calendarForEvent = eventStore.calendar(withIdentifier: calendarIdentifier)
        {
            if important || shouldAllbeAlert {
                let newEvent = EKEvent(eventStore: eventStore)
                
                newEvent.calendar = calendarForEvent
                newEvent.title = title
                newEvent.startDate = start
                newEvent.endDate = end
                newEvent.notes = body
                newEvent.recurrenceRules = [EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: EKRecurrenceEnd(occurrenceCount: 99))]
                
                let alarm = EKAlarm(relativeOffset: -1800) // 30' before
                newEvent.addAlarm(alarm)
                
                // Save the calendar using the Event Store instance
                
                do {
                    try eventStore.save(newEvent, span: .futureEvents, commit: true)
                    delegate?.eventDidAdd()
                    
                } catch {
                    /*
                     let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                     let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alert.addAction(OKAction)
                     
                     self.present(alert, animated: true, completion: nil)*/
                    print("Event could not save: ", title)
                }
            }
        }
    }
    
    func deleteEvents() {
        for day in weekCollection {
            //For every day
            for mission in day {
                //For every mission
                let totalMinuteStart = mission.start * 5
                let hourStart = totalMinuteStart / 60
                let minuteStart = totalMinuteStart % 60
                let start = initialDatePickerValue(hour: hourStart, minute: minuteStart, mission: mission)
                
                let totalMinuteEnd = mission.end * 5
                let hourEnd = totalMinuteEnd / 60
                let minuteEnd = totalMinuteEnd % 60
                let end = initialDatePickerValue(hour: hourEnd, minute: minuteEnd, mission: mission)
                
                removeAllEventsMatchingPredicate(start: start, end: end)
            }
        }
    }
    
    func removeAllEventsMatchingPredicate(start: Date, end: Date) {
        var calendarIdentifier = ""
        
        let calendars :[EKCalendar] = self.eventStore.calendars(for: EKEntityType.event)
        for aCal in calendars
        {
            if aCal.title == "TimeBot" {
                calendarIdentifier = aCal.calendarIdentifier
                break
            }
        }
        
        if let calendarForEvent = eventStore.calendar(withIdentifier: calendarIdentifier) {
            
            let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: [calendarForEvent])
            
            print("startDate:\(start) endDate:\(end)")
            let event = eventStore.events(matching: predicate) as [EKEvent]!
            
            if event != nil {
                for i in event! {
                    do {
                        (try eventStore.remove(i, span: EKSpan.thisEvent, commit: true))
                    }
                    catch let error {
                        print("Error removing events: ", error)
                    }
                    
                }
            }
        }
    }
    
    func initialDatePickerValue(hour: Int, minute: Int, mission: Mission) -> Date {
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .weekday , .hour, .minute, .second]
        
        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.weekday = weekday(from: mission)
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents)!
    }
    
    func weekday(from mission: Mission) -> Int {
        let day = mission.repeatDay[0]
        if day == 0 {
            return 2
        }
        else if day == 1 {
            return 3
        }
        else if day == 2 {return 4}
        else if day == 3 {return 5}
        else if day == 4 {return 6}
        else if day == 5 {return 7}
        else if day == 6 {return 1}
        
        return 0
    }
    
    func toSettings() {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
        }
    }
}
