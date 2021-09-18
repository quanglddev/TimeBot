//
//  LoadSaveHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/15/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import os.log
import ChameleonFramework


extension HomeVC {
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
    
    /*
    func loadSampleWeek() {
        var monday = [Mission]()
        monday = [Mission(title: "Yolo", body: "Say hello to y'all sdfjadadfhjafhjhdjhajfsjsjjsjfdfhahkfhdfkahfhuofqhufuoqbuobubibksdabsbkdsafafhfkjdshfdhfouhwihfisbdbksdhfahsdfhadofhouhouwqhuhfdshjfbaksjdfkjdfkahfdhfoqf", length: 20, color: RandomFlatColor(), repeatDay: [0], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]
        
        var tuesday = [Mission]()
        tuesday = [Mission(title: "Yolo Tuesday", body: "Say hello to y'all", length: 20, color: RandomFlatColor(), repeatDay: [1], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]
        
        var wednesday = [Mission]()
        wednesday = [Mission(title: "Yolo Wednesday", body: "Say hello to y'all", length: 20, color: RandomFlatColor(), repeatDay: [2], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]
        
        var thursday = [Mission]()
        thursday = [Mission(title: "Yolo Thursday", body: "Say hello to y'all", length: 20, color: RandomFlatColor(), repeatDay: [3], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]
        
        var friday = [Mission]()
        friday = [Mission(title: "Yolo Friday", body: "Say hello to y'all", length: 20, color: RandomFlatColor(), repeatDay: [4], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]
        
        var saturday = [Mission]()
        saturday = [Mission(title: "Yolo Saturday", body: "Say hello to y'all", length: 20, color: RandomFlatColor(), repeatDay: [5], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]
        
        var sunday = [Mission]()
        sunday = [Mission(title: "Yolo Sunday", body: "Say hello to y'all", length: 20, color: RandomFlatColor(), repeatDay: [6], start: 0, end: 0, prioritized: false, isDone: false, caculated: true)!]

        weekCollection = [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    }*/
}
