//
//  AddMissionHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/23/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension HomeVC: AddMissionTVCDelegate {
    func missionDidAdd(_ sender: AddMissionTVC) {
        if let mission = sender.mission {
            var newIndexPath = [IndexPath]()
            newIndexPath.removeAll()
            
            for i in 0..<mission.repeatDay.count {
                newIndexPath += [IndexPath(row: weekCollection[mission.repeatDay[i]].count, section: mission.repeatDay[i])]
                
                weekCollection[mission.repeatDay[i]].append(mission)
            }
            
            weekTableView.beginUpdates()
            weekTableView.insertRows(at: newIndexPath, with: .automatic)
            weekTableView.endUpdates()
            
            //Reschedule every time a mission is added
            setupCalendar(completion: {_ in
                if self.userDefaults.bool(forKey: defaultsKeys.shouldReSchedule) {
                    if self.eventStore.calendar(withIdentifier: "TimeBotCalendar") != nil {
                        self.deleteEvents()
                        self.scheduleMissions()
                        self.organizeMissions()
                        self.setupEvents()
                    }
                }
            })
        }
    }
}
