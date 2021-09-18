//
//  WeekdayCVCell.swift
//  TimeBot
//
//  Created by QUANG on 3/13/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import ChameleonFramework

/*
class WeekdayCVCell: UICollectionViewCell {
    
    @IBOutlet weak var MissionTableOutlet: UITableView!
    
    var weekday = [[Mission]]()
    
    var mission: [Mission]? {
        didSet {
            self.updateUI()
        }
    }
    
    var selectedDay: Int!
    
    func updateUI() {
        
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 15.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.clipsToBounds = false
        
        MissionTableOutlet.layer.cornerRadius = 15.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        MissionTableOutlet.dataSource = self
        MissionTableOutlet.delegate = self
        
        if let savedWeek = loadWeek() {
            weekday = savedWeek
        }
        else {
            // Load the sample data.
            print("Error loading")
        }
    }
}

extension WeekdayCVCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = mission?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MissionTVCell"
        
        guard let cell = MissionTableOutlet.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MissionTVCell else {
            fatalError("The dequeued cell is not an instance of MissionTVCell.")
        }
        
        let mission = self.mission?[indexPath.row]
        
        cell.lblTitle.text = mission?.title
        cell.lblTime.text = 0.hourFrom(minuteth: (mission?.length)!)
        cell.cbIsDone.setOn((mission?.isDone)!, animated: false)
        cell.backgroundColor = mission?.color
        cell.lblTitle.textColor = ContrastColorOf((mission?.color)!, returnFlat: true)
        cell.lblTime.textColor = ContrastColorOf((mission?.color)!, returnFlat: true)
        cell.cbIsDone.onTintColor = ContrastColorOf((mission?.color)!, returnFlat: false)
        cell.cbIsDone.onCheckColor = ContrastColorOf((mission?.color)!, returnFlat: false)
        cell.mission = mission
        //cell.cbIsDone.onTintColor = RandomFlatColor()
        //cell.cbIsDone.onCheckColor = cell.cbIsDone.onTintColor
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            weekday[selectedDay].remove(at: indexPath.row)
            saveWeek()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}
*/
