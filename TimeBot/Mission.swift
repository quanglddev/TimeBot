//
//  Weekday.swift
//  TimeBot
//
//  Created by QUANG on 3/14/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import Dotzu

class Mission: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let title = "title"
        static let body = "body"
        static let length = "length"
        static let color = "color"
        static let start = "start"
        static let end = "end"
        static let prioritized = "prioritized"
        static let isDone = "isDone"
        static let repeatDay = "repeatDay" //-1 if none 0...6
        static let caculated = "caculated"
        static let morning = "morning"
        static let afternoon = "afternoon"
        static let night = "night"
        static let id = "id"
        /* 
         let uuid = UUID().uuidString
         print(uuid)
         */
    }
    
    //MARK: Properties
    var title: String
    var body: String?
    var length: Int
    var color: UIColor
    var repeatDay: [Int]
    var start: Int //In minuteth
    var end: Int //In minuteth
    var prioritized: Bool
    var isDone: Bool
    var caculated: Bool
    var morning: Bool
    var afternoon: Bool
    var night: Bool
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Mission")
    
    
    //MARK: Initialization
    init?(title: String, body: String?, length: Int, color: UIColor, repeatDay: [Int], start: Int, end: Int, prioritized: Bool, isDone: Bool, caculated: Bool, morning: Bool, afternoon: Bool, night: Bool) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        guard !title.isEmpty else {
            return nil
        }
        
        // The start & end must be beween 0 and 288 inclusively
        guard (start >= 0) && (start <= 288) && (end >= 0) && (end <= 288) else {
            return nil
        }
        
        self.title = title
        self.body = body
        self.length = length
        self.color = color
        self.repeatDay = repeatDay
        self.start = start
        self.end = end
        self.prioritized = prioritized
        self.isDone = isDone
        self.caculated = caculated
        self.morning = morning
        self.afternoon = afternoon
        self.night = night
    }
    
    
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(body, forKey: PropertyKey.body)
        aCoder.encode(length, forKey: PropertyKey.length)
        aCoder.encode(color, forKey: PropertyKey.color)
        aCoder.encode(length, forKey: PropertyKey.length)
        aCoder.encode(repeatDay, forKey: PropertyKey.repeatDay)
        aCoder.encode(start, forKey: PropertyKey.start)
        aCoder.encode(end, forKey: PropertyKey.end)
        aCoder.encode(prioritized, forKey: PropertyKey.prioritized)
        aCoder.encode(isDone, forKey: PropertyKey.isDone)
        aCoder.encode(caculated, forKey: PropertyKey.caculated)
        aCoder.encode(morning, forKey: PropertyKey.morning)
        aCoder.encode(afternoon, forKey: PropertyKey.afternoon)
        aCoder.encode(night, forKey: PropertyKey.night)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The name is required. If we cannot decode a name string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            Logger.error("Unable to decode the name.")
            return nil
        }
        
        // Because body is an optional property, just use conditional cast.
        let body = aDecoder.decodeObject(forKey: PropertyKey.body) as? String
        
        let length = aDecoder.decodeInteger(forKey: PropertyKey.length)
                
        guard let repeatDay = aDecoder.decodeObject(forKey: PropertyKey.repeatDay) as? [Int] else {
            Logger.error("Unable to decode the repeat.")
            return nil
        }
        
        let prioritized = aDecoder.decodeBool(forKey: PropertyKey.prioritized)
        
        let start = aDecoder.decodeInteger(forKey: PropertyKey.start)
        
        let end = aDecoder.decodeInteger(forKey: PropertyKey.end)
        
        guard let color = aDecoder.decodeObject(forKey: PropertyKey.color) as? UIColor else {
            Logger.error("Unable to decode color.")
            return nil
        }
        
        let isDone = aDecoder.decodeBool(forKey: PropertyKey.isDone)
        
        let caculated = aDecoder.decodeBool(forKey: PropertyKey.caculated)
        
        let morning = aDecoder.decodeBool(forKey: PropertyKey.morning)
        let afternoon = aDecoder.decodeBool(forKey: PropertyKey.afternoon)
        let night = aDecoder.decodeBool(forKey: PropertyKey.night)
        
        // Must call designated initializer.
        self.init(title: title, body: body, length: length, color: color, repeatDay: repeatDay, start: start, end: end, prioritized: prioritized, isDone: isDone, caculated: caculated, morning: morning, afternoon: afternoon, night: night)
    }
}
