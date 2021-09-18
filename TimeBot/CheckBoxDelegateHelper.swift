//
//  CheckBoxDelegateHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/24/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension HomeVC: CheckBoxDelegate {
    
    func checkBoxDidChange(cell: MissionTVCell, isChecked: Bool) {
        DispatchQueue.global(qos: .background).async {
            guard let indexPath = self.weekTableView.indexPath(for: cell) else {
                return
            }
            
            let missionToReplace = self.weekCollection[indexPath.section][indexPath.row]
            let isDone = !missionToReplace.isDone
            let new = Mission(title: missionToReplace.title, body: missionToReplace.body, length: missionToReplace.length, color: missionToReplace.color, repeatDay: missionToReplace.repeatDay, start: missionToReplace.start, end: missionToReplace.end, prioritized: missionToReplace.prioritized, isDone: isDone, caculated: missionToReplace.caculated, morning: missionToReplace.morning, afternoon: missionToReplace.afternoon, night: missionToReplace.night)!
            self.weekCollection[indexPath.section].remove(at: indexPath.row)
            self.weekCollection[indexPath.section].insert(new, at: indexPath.row)
            
            self.weekCollection[indexPath.section][indexPath.row].isDone = isChecked
            
            /*
             DispatchQueue.main.async {
             cell.cbIsDone.setOn(cell.cbIsDone.on, animated: true)
             //self.weekTableView.reloadData()
             }*/
            
            self.saveWeek()
            
            self.pictureTable()
        }
    }
}
