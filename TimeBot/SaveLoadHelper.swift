//
//  SaveLoadHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/26/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension InfoTVC {
    func loadWeek() -> [[Mission]]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Week.ArchiveURL.path) as? [[Mission]]
    }
    
    func saveWeek() {
        //weekCollection = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(weekCollection, toFile: Week.ArchiveURL.path)
        if isSuccessfulSave {
            print("Successfully saved.")
        } else {
            print("Failed to save ...")
        }
    }
}
