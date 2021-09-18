//
//  ScheduleHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/21/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import Dotzu

extension HomeVC {
    func scheduleMissions() {
        DispatchQueue.global(qos: .background).async {
            
            let allMinuteth: [Int] = Array(0...288)
            
            var countday = 0
            
            //For every day
            for i in 0..<self.weekCollection.count {
                countday += 1
                if countday == 7 {
                    print()
                }
                
                self.used.removeAll()
                
                //Get used and sort
                for j in 0..<self.weekCollection[i].count {
                    if self.weekCollection[i][j].prioritized {
                        for minuteth in self.weekCollection[i][j].start...self.weekCollection[i][j].end {
                            if !self.weekCollection[i][j].isDone {
                                self.used.append(minuteth)
                            }
                        }
                    }
                }
                self.used += self.preservedMission()
                self.used = Array(Set(self.used))
                self.used = self.used.sorted()
                
                //Get available minuteth
                var availabel = [Int]()
                availabel.removeAll()
                /*
                 let filteredArray = allMinuteth.filter{ !self.used.contains($0) }
                 availabel.append(contentsOf: filteredArray)
                 availabel = availabel.filter{ $0 != 0 }*/
                
                //print(availabel)
                /*
                 //Creat an array that will be used later. Optimized
                 var availabelSpot: Int = 0
                 
                 if used.count >= availabel.count {
                 availabelSpot = availabel.count
                 }
                 else {
                 availabelSpot = 288 - used.count
                 }*/
                
                for j in 0..<self.weekCollection[i].count {
                    
                    if self.weekCollection[i][j].isDone {
                        continue
                    }
                    
                    print(self.weekCollection[i][j].title)
                    
                    var restrictedMinuteth = [Int]()
                    
                    if self.weekCollection[i][j].morning && self.weekCollection[i][j].afternoon && self.weekCollection[i][j].night {
                        restrictedMinuteth = allMinuteth
                    }
                    else {
                        if self.weekCollection[i][j].morning { restrictedMinuteth += self.morning }
                        if self.weekCollection[i][j].afternoon { restrictedMinuteth += self.afternoon }
                        if self.weekCollection[i][j].night { restrictedMinuteth += self.night }
                    }
                    
                    //print(restrictedMinuteth)
                    
                    let filteredArray = restrictedMinuteth.filter { !self.used.contains($0) }
                    availabel.removeAll()
                    availabel.append(contentsOf: filteredArray)
                    availabel = availabel.filter{ $0 != 0 }
                    
                    if !self.weekCollection[i][j].prioritized {
                        //print(mission.title)
                        
                        if availabel.count < self.weekCollection[i][j].length {
                            Logger.warning(availabel)
                            Logger.warning(self.weekCollection[i][j].length)
                            
                            self.weekCollection[i][j].caculated = false
                            self.weekCollection[i][j].start = 0
                            self.weekCollection[i][j].end = 0
                            break
                        }
                        else {
                            //Start loop here
                            if self.used.count > availabel.count {
                                let Index = availabel.count - self.weekCollection[i][j].length
                                //print(Index)
                                
                                var loopCount = 0
                                
                                while true {
                                    loopCount += 1
                                    
                                    guard let check = availabel[safe: Int(arc4random_uniform(UInt32(Index)))] else {
                                        return
                                    }
                                    
                                    //print(check)
                                    
                                    let randomStart = check
                                    
                                    let temp: [Int] = Array(randomStart...randomStart + self.weekCollection[i][j].length)
                                    //print(temp)
                                    
                                    if self.containsAll(father: availabel, son: temp) {
                                        //Add
                                        self.weekCollection[i][j].start = randomStart
                                        self.weekCollection[i][j].end = randomStart + self.weekCollection[i][j].length
                                        self.weekCollection[i][j].caculated = true
                                        //Change caculated
                                        self.used += Array(self.weekCollection[i][j].start...self.weekCollection[i][j].end)
                                        self.used = self.used.filter{ $0 != 0 }
                                        let filteredArray = restrictedMinuteth.filter{ !self.used.contains($0) }
                                        availabel.removeAll()
                                        availabel.append(contentsOf: filteredArray)
                                        availabel = availabel.filter{ $0 != 0 }
                                        
                                        if self.weekCollection[i][j].start == 0 {
                                            print(availabel)
                                        }
                                        
                                        break
                                    }
                                    else {
                                        if loopCount == 25 {
                                            //Add in soonest
                                            for x in 0..<availabel.count {
                                                let temp: [Int] = Array(availabel[x]...availabel[x] + self.weekCollection[i][j].length)
                                                if self.containsAll(father: availabel, son: temp) {
                                                    self.weekCollection[i][j].start = availabel[x]
                                                    self.weekCollection[i][j].end = availabel[x] + self.weekCollection[i][j].length
                                                    self.weekCollection[i][j].caculated = true
                                                    
                                                    self.used += Array(self.weekCollection[i][j].start...self.weekCollection[i][j].end)
                                                    self.used = self.used.filter{ $0 != 0 }
                                                    let filteredArray = restrictedMinuteth.filter{ !self.used.contains($0) }
                                                    availabel.removeAll()
                                                    availabel.append(contentsOf: filteredArray)
                                                    availabel = availabel.filter{ $0 != 0 }
                                                    
                                                    if self.weekCollection[i][j].start == 0 {
                                                        print(availabel)
                                                    }
                                                    break
                                                }
                                            }
                                            
                                            break
                                        }
                                    }
                                }
                            }
                            else {
                                let randomLoop = Int(arc4random_uniform(UInt32(self.used.count)))
                                var countLoop = 0
                                var tempStart = 0
                                
                                for x in 0..<self.used.count - 1 {
                                    if self.used[x + 1] - self.used[x] > self.weekCollection[i][j].length {
                                        countLoop += 1
                                        tempStart = self.used[x]
                                    }
                                    if countLoop > randomLoop {
                                        break
                                    }
                                    if countLoop == randomLoop && tempStart != 0 {
                                        //Add here
                                        self.weekCollection[i][j].start = tempStart
                                        self.weekCollection[i][j].end = tempStart + self.weekCollection[i][j].length
                                        self.weekCollection[i][j].caculated = true
                                        
                                        self.used += Array(tempStart...tempStart + self.weekCollection[i][j].length)
                                        self.used = self.used.filter{ $0 != 0 }
                                        let filteredArray = restrictedMinuteth.filter{ !self.used.contains($0) }
                                        availabel.removeAll()
                                        availabel.append(contentsOf: filteredArray)
                                        availabel = availabel.filter{ $0 != 0 }
                                        
                                        if self.weekCollection[i][j].start == 0 {
                                            print(availabel)
                                        }
                                        
                                        break
                                    }
                                }
                            }
                        }
                        if self.weekCollection[i][j].start == 0 {
                            //not add
                            self.weekCollection[i][j].caculated = false
                            self.weekCollection[i][j].start = 0
                            self.weekCollection[i][j].end = 0
                        }
                    }
                    //print(used.count)
                }
            }
            self.saveWeek()
            
            self.userDefaults.setValue(false, forKey: defaultsKeys.shouldReSchedule)
        }
    }
    
    func preservedMission() -> [Int] {
        var sleep = [Int]()
        sleep.removeAll()
        sleep += Array(0...84)
        sleep += Array(276...288)
        
        let nap: [Int] = Array(132...144)
        
        return sleep + nap
    }
}
