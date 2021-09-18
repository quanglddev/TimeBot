//
//  AddMissionTVC LoadSaveHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/20/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension AddMissionTVC {
    func loadWeek() -> [[Mission]]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Week.ArchiveURL.path) as? [[Mission]]
    }
    
    func saveWeek() {
        //weekCollection = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(weekCollection, toFile: Week.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save ...", log: OSLog.default, type: .error)
        }
    }
}
