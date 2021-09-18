//
//  DayRepeatPickerTVC.swift
//  TimeBot
//
//  Created by QUANG on 3/21/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import os.log

class DayRepeatPickerTVC: UITableViewController {
    
    var selectedIndex = [Int]()
    
    var repeatDay: [Int]!

    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
    override func viewDidLayoutSubviews() {
        if let savedRepeatDay = repeatDay {
            for i in 0..<savedRepeatDay.count {
                let indexPath = IndexPath(row: i, section: 0)
                let cell = tableView.cellForRow(at: indexPath)
                
                cell?.accessoryType = .checkmark
            }
        }
    }*/

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            
            for i in 0..<selectedIndex.count {
                if selectedIndex[i] == indexPath.row {
                    selectedIndex.remove(at: i)
                    break
                }
            }
        }
        else {
            cell?.accessoryType = .checkmark
            selectedIndex += [indexPath.row]
        }
        
        selectedIndex = Array(Set(selectedIndex))
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(selectedIndex)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        repeatDay = selectedIndex
    }
    

}
