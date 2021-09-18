//
//  ColorsPickerTVC.swift
//  TimeBot
//
//  Created by QUANG on 3/21/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import ChameleonFramework
import os.log

class ColorsPickerTVC: UITableViewController {
    
    func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var colorArray = [UIColor]()
    
    var color: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var colors = [UIColor]()
        
        for _ in 0...15 {
            colors += [getRandomColor()]
        }
        
        colorArray = Array(Set(colors))
        
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        //dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
        
        cell.contentView.backgroundColor = colorArray[indexPath.row]

        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if color == nil {
            if let index = tableView.indexPathForSelectedRow {
                color = colorArray[index.row]
            }
            else {
                color = RandomFlatColor()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        color = colorArray[indexPath.row]
        
        dismiss(animated: true, completion: nil)
    }
}
