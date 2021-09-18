//
//  Week.swift
//  TimeBot
//
//  Created by QUANG on 3/15/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import os.log

class Week: NSObject, NSCoding {
    
    //MARK: Types
    struct PropertyKey {
        static let weekdays = "weekdays"
    }
    
    //MARK: Properties
    var weekdays = [[Mission]]()
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Week")
    
    
    //MARK: Initialization
    init?(weekdays: [[Mission]]) {
        
        print(weekdays.count)
        
        // Initialization should fail if there is no name or if the rating is negative.
        guard weekdays.count != 7 else {
            return nil
        }
        
        self.weekdays = weekdays
    }
    
    
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(weekdays, forKey: PropertyKey.weekdays)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let weekdays = aDecoder.decodeObject(forKey: PropertyKey.weekdays) as? [[Mission]] else {
            os_log("Unable to decode weekdays.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(weekdays: weekdays)
    }
}
