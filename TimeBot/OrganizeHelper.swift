//
//  OrganizeHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/22/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension HomeVC {
    func organizeMissions() {
        
        DispatchQueue.global(qos: .background).async {
            for day in 0..<self.weekCollection.count {
                //for every day
                
                //No need to organize day with only 1 or 0 mission
                if self.weekCollection[day].count <= 1 {
                    continue
                }
                
                //Sort start of missions
                var starts = [Int]()
                starts.removeAll()
                for mission in 0..<self.weekCollection[day].count {
                    starts += [self.weekCollection[day][mission].start]
                }
                
                for i in 0..<starts.count {
                    var y = i // `y` is the index of the item we're comparing in the sorted pile with the next item in the unsorted pile
                    let temp = starts[y] // Remember the next item in the unsorted pile that will eventually be put into the correct position
                    let missionTemp = self.weekCollection[day][y]
                    while y > 0 && temp < starts[y-1] { // Objects conforming to Comparable can use `<`
                        // While we haven't hit the beginning of the array,
                        // and while our next unsorted item is less than the sorted item we're comparing it to,
                        // we don't yet have a sorted array. Keep shifting the items to the right until we find the right spot to insert
                        // `temp`, our next unsorted item.
                        starts[y] = starts[y - 1]
                        self.weekCollection[day][y] = self.weekCollection[day][y - 1]
                        
                        // Move the marker to the next item in the sorted array, and, on the next loop, repeat if necessary
                        y -= 1
                    }
                    starts[y] = temp // We found the right spot to insert the next unsorted item. Insert it!
                    self.weekCollection[day][y] = missionTemp
                }
            }

        }
    }
    
    func organizeByDone() {
        var newWeek = [[Mission]]()
        var newDay = [Mission]()
        
        for day in weekCollection {
            newDay.removeAll()
            
            for mission in day {
                if !mission.isDone {
                    newDay.append(mission)
                }
            }
            
            for mission in day {
                if mission.isDone {
                    newDay.append(mission)
                }
            }
            
            newWeek.append(newDay)
        }
        
        weekCollection = newWeek
        
        saveWeek()
    }
}
