//
//  AddMissionTVC.swift
//  TimeBot
//
//  Created by QUANG on 3/19/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import ChameleonFramework
import ATHMultiSelectionSegmentedControl
import SCLAlertView
import Dotzu

protocol AddMissionTVCDelegate {
    func missionDidAdd(_ sender: AddMissionTVC)
}

class AddMissionTVC: UITableViewController, MultiSelectionSegmentedControlDelegate {
    
    //MARK: Delegate Handler
    var addMissionDelegate: AddMissionTVCDelegate?
    
    //MARK: OUTLETS
    
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var scImportantOutlet: UISegmentedControl!
    @IBOutlet var btnStartOutlet: UIButton!
    @IBOutlet var btnEndOutlet: UIButton!
    @IBOutlet var tvBody: UITextView!
    
    @IBOutlet var scMultipleDay: MultiSelectionSegmentedControl!
    
    @IBOutlet var scMultiplePeriod: MultiSelectionSegmentedControl!
    
    
    @IBOutlet var btnSaveOutlet: UIBarButtonItem!
    
    @IBOutlet var lblDuration: UILabel!
    //@IBOutlet var colorView: UIView!
    //@IBOutlet var colorCell: UITableViewCell!
    
        
    @IBOutlet var sliderOutlet: UISlider!
    
    //MARK: PROPERTIES
    var mission: Mission?
    var missions = [Mission]()
    
    var weekCollection = [[Mission]]()
    
    var pickedHoursStart: String?
    var pickedHoursEnd: String?
    var pickedDays: [Int]?
    var pickedColor: UIColor!
    var isMorning: Bool = true
    var isAfternoon: Bool = true
    var isNight: Bool = true
    
    let userDefaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let shouldReSchedule = "shouldReSchedule"
        static let isEnglish = "isEnglish"
    }
    
    var language: String?
    var isEditingMission: Bool!

    //MARK: ACTIONS
    
    @IBAction func scImportantAction(_ sender: UISegmentedControl) {
        updateSaveButtonState()
        
        if scImportantOutlet.selectedSegmentIndex == 0 {
            btnStartOutlet.isEnabled = true
            btnEndOutlet.isEnabled = true
            sliderOutlet.isEnabled = false
            lblDuration.isEnabled = false
            scMultiplePeriod.setEnabled(false, forSegmentAtIndex: 0)
            scMultiplePeriod.setEnabled(false, forSegmentAtIndex: 1)
            scMultiplePeriod.setEnabled(false, forSegmentAtIndex: 2)
            
            isMorning = false
            isAfternoon = false
            isNight = false
            
            guard let start = minuteth(from: btnStartOutlet.title(for: .normal)!) else {
                return
            }
            
            guard let end = minuteth(from: btnEndOutlet.title(for: .normal)!) else {
                return
            }
            
            if start <= 0 || end <= 0 {
                btnSaveOutlet.isEnabled = false
            }
            else {
                btnSaveOutlet.isEnabled = true
            }
        }
        else {
            btnStartOutlet.isEnabled = false
            btnEndOutlet.isEnabled = false
            sliderOutlet.isEnabled = true
            lblDuration.isEnabled = true
            scMultiplePeriod.setEnabled(true, forSegmentAtIndex: 0)
            scMultiplePeriod.setEnabled(true, forSegmentAtIndex: 1)
            scMultiplePeriod.setEnabled(true, forSegmentAtIndex: 2)
            
            isMorning = false
            isAfternoon = false
            isNight = false
        }
        tableView.reloadData()
    }
    
    var missionDuration = 0
    @IBAction func sliderAction(_ sender: UISlider) {
        updateSlider()
    }
    
    func setupIfEditing() {
        // Set up views if editing an existing Task.
        if let mission = mission {
            tfTitle.text = mission.title
            scMultipleDay.selectedSegmentIndices = mission.repeatDay.sorted()
            pickedDays = mission.repeatDay.sorted()
            scImportantOutlet.selectedSegmentIndex = mission.prioritized ? 0 : 1
            sliderOutlet.value = Float(mission.length)
            lblDuration.text = durationLengthFrom(minuteth: mission.length)
            
            isMorning = false
            isAfternoon = false
            isNight = false
            
            if mission.morning {
                scMultiplePeriod.selectedSegmentIndices += [0]
                isMorning = true
            }
            if mission.afternoon {
                scMultiplePeriod.selectedSegmentIndices += [1]
                isAfternoon = true
            }
            if mission.afternoon {
                scMultiplePeriod.selectedSegmentIndices += [2]
                isNight = true
            }
            
            btnStartOutlet.setTitle("STARTS".localized(lang: self.language!) + "     \(0.hourFrom(minuteth: mission.start))", for: .normal)
            btnEndOutlet.setTitle("ENDS".localized(lang: self.language!) + "     \(0.hourFrom(minuteth: mission.end))", for: .normal)

            tvBody.text = mission.body
            
            //Disable change name
            tfTitle.isUserInteractionEnabled = false
            
            //Set true
            isEditingMission = true
            
            if scImportantOutlet.selectedSegmentIndex == 0 {
                btnStartOutlet.isEnabled = true
                btnEndOutlet.isEnabled = true
            }
            
            tableView.reloadData()
            
            btnSaveOutlet.isEnabled = true
        }
    }
    
    func durationLengthFrom(minuteth: Int) -> String {
        let missionDuration = minuteth
        let hours = missionDuration * 5 / 60
        let minutes = (missionDuration - hours * 60 / 5) * 5
        if(hours == 0){
            return "\(minutes) " + "MINUTES".localized(lang: language!)
        }
        else if (minutes == 0){
            return "\(hours) " + "HOURS".localized(lang: language!)
        }
        else {
            return "\(hours) " + "HOURS".localized(lang: language!) + " \(minutes) " + "MINUTES".localized(lang: language!)
        }
    }
    
    func updateSlider() {
        missionDuration = Int(sliderOutlet.value)
        let hours = missionDuration * 5 / 60
        let minutes = (missionDuration - hours * 60 / 5) * 5
        if(hours == 0){
            lblDuration.text = "\(minutes) " + "MINUTES".localized(lang: language!)
        }
        else if (minutes == 0){
            lblDuration.text = "\(hours) " + "HOURS".localized(lang: language!)
        }
        else {
            lblDuration.text = "\(hours) " + "HOURS".localized(lang: language!) + " \(minutes) " + "MINUTES".localized(lang: language!)
        }
    }
    
    @IBAction func scDayAction(_ sender: UISegmentedControl) {
        /*
        pickedRepeatDay?.removeAll()
        lblRepeat.text = "Never"
        
        pickedRepeatDay?.append(scDayOutlet.selectedSegmentIndex)*/
    }
    
    @IBAction func btnStartAction(_ sender: UIButton) {
    }
    
    @IBAction func btnEndAction(_ sender: UIButton) {
    
    }
    
    @IBAction func btnSaveAction(_ sender: UIBarButtonItem) {
    }

    @IBAction func btnCancelButton(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            Logger.error("The AddMissionTVC is not inside a navigation controller.")
            fatalError("The AddMissionTVC is not inside a navigation controller.")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if scImportantOutlet.selectedSegmentIndex == 0 {
            if indexPath.section == 2 {
                return 0
            }
        }
        else if scImportantOutlet.selectedSegmentIndex == 1 {
            if indexPath.section == 1 && indexPath.row == 1 {
                return 0
            }
        }
        
        if indexPath.section == 3 {
            return 180.0
        }
        
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 2 {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            view.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.5, animations: {
                view.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: DEFAULTS
    override func viewDidAppear(_ animated: Bool) {
        scMultiplePeriod.selectedSegmentIndices = [0, 1, 2]
        
        setupIfEditing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isEnglish = userDefaults.bool(forKey: defaultsKeys.isEnglish)
        
        if isEnglish {
            self.language = "en"
        }
        else {
            self.language = "vi"
        }
        
        tfTitle.placeholder = "TITLE".localized(lang: language!)
        btnSaveOutlet.title = "DONE".localized(lang: language!)
        scImportantOutlet.setTitle("YES".localized(lang: language!), forSegmentAt: 0)
        scImportantOutlet.setTitle("NO".localized(lang: language!), forSegmentAt: 1)
        btnStartOutlet.setTitle("DEFAULT_START".localized(lang: language!), for: .normal)
        btnEndOutlet.setTitle("DEFAULT_END".localized(lang: language!), for: .normal)
        
        setupTextInput()
        
        //colorView.backgroundColor = RandomFlatColor()
        //colorCell.backgroundColor = colorView.backgroundColor
        
        tfTitle.becomeFirstResponder()
        
        updateSlider()
        
        pickedColor = RandomFlatColor()
        
        /* No editing
        // Set up views if editing an existing Mission.
        if let mission = mission {
            tfTitle.text = mission.title.uppercased()
            scImportantOutlet.selectedSegmentIndex = mission.prioritized ? 0 : 1
            lblRepeat.text = "\(mission.repeatDay.description)" //Change this
            btnStartOutlet.setTitle("Starts     \(0.hourFrom(minuteth: mission.start))", for: .normal)
            btnEndOutlet.setTitle("Ends     \(0.hourFrom(minuteth: mission.end))", for: .normal)
            colorView.backgroundColor = mission.color
            tvBody.text = mission.body
        }*/
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
        tfTitle.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //view.addGestureRecognizer(tap)
        
        scMultipleDay.insertSegmentsWithTitles(["Mon".localized(lang: language!), "Tue".localized(lang: language!), "Wed".localized(lang: language!), "Thu".localized(lang: language!), "Fri".localized(lang: language!), "Sat".localized(lang: language!), "Sun".localized(lang: language!)])
        scMultipleDay.delegate = self
        
        scMultiplePeriod.insertSegmentsWithTitles(["MORNING".localized(lang: language!), "AFTERNOON".localized(lang: language!), "NIGHT".localized(lang: language!)])
        scMultiplePeriod.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        //scMultiplePeriod.selectedSegmentIndices = [0, 1, 2]
    }
    
    
    /**
     Delegate method for `MultiSelectionSegmentedControl`. Called only when the user
     interacts with the control and not when the control is configured programmatically!
     */
    func multiSelectionSegmentedControl(_ control: MultiSelectionSegmentedControl, selectedIndices indices: [Int]) {
        
        updateSaveButtonState()
        
        if control == scMultipleDay {
            pickedDays = indices
            pickedDays = Array(Set(pickedDays!)).sorted()
        }
        else if control == scMultiplePeriod {
            isMorning = indices.contains(0) ? true : false
            isAfternoon = indices.contains(1) ? true : false
            isNight = indices.contains(2) ? true : false
            
            print(isMorning)
            print(isAfternoon)
            print(isNight)
        }
        else {
            Logger.error("WHAT THE F***?")
            fatalError("WHAT THE F***?")
        }
    }
    
    func handleTap() {
        if tfTitle.isFirstResponder {
            tfTitle.resignFirstResponder()
        }
        
        if tvBody.isFirstResponder {
            tvBody.resignFirstResponder()
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    //MARK: PRIVATE METHODS
    func updateSaveButtonState() {
        if !(tfTitle.text?.isEmpty)! {
            //btnSaveOutlet.isEnabled = true
            
            if scImportantOutlet.selectedSegmentIndex == 0 {
                if let start = minuteth(from: btnStartOutlet.title(for: .normal)!) {
                    if start <= 0 {
                        btnSaveOutlet.isEnabled = false
                    }
                    else {
                        btnSaveOutlet.isEnabled = true
                    }
                    
                    if let end = minuteth(from: btnEndOutlet.title(for: .normal)!) {
                        if end > start || scImportantOutlet.selectedSegmentIndex == 1 {
                            if end <= 0 {
                                btnSaveOutlet.isEnabled = false
                            }
                            else {
                                btnSaveOutlet.isEnabled = true
                            }
                        }
                    }
                }
            }
            else {
                if scMultiplePeriod.selectedSegmentIndices.isEmpty {
                    btnSaveOutlet.isEnabled = false
                }
                else {
                    if scMultipleDay.selectedSegmentIndices.isEmpty {
                        btnSaveOutlet.isEnabled = false
                    }
                    else {
                        btnSaveOutlet.isEnabled = true
                    }
                }
            }
            
            if let pd = pickedDays {
                if scImportantOutlet.selectedSegmentIndex == 1 {
                    btnSaveOutlet.isEnabled = true
                }
                else {
                    btnSaveOutlet.isEnabled = false
                }
                if pd.isEmpty {
                    btnSaveOutlet.isEnabled = false
                }
                else {
                    btnSaveOutlet.isEnabled = true
                }
            }
            else {
                btnSaveOutlet.isEnabled = false
            }
        }
        else {
            btnSaveOutlet.isEnabled = false
        }
    }
    
    @IBAction func unwindToThisVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ColorsPickerTVC, let color = sourceViewController.color {
                //self.colorView.backgroundColor = color
                //self.colorCell.backgroundColor = color
                self.pickedColor = color
        }/*
        else if let sourceViewController = sender.source as? DayRepeatPickerTVC, let repeatDay = sourceViewController.repeatDay {
            lblRepeat.text = repeatDayToString(from: repeatDay)
            
            if lblRepeat.text == "Never" {
                scDayOutlet.isEnabled = true
            }
            else {
                scDayOutlet.isEnabled = false
            }
            
            print(lblRepeat.text!)
            pickedRepeatDay = repeatDay
            print(pickedRepeatDay ?? "0fanifdkfjk")
        }*/
        
        let isEnglish = userDefaults.bool(forKey: defaultsKeys.isEnglish)
        
        if isEnglish {
            self.language = "en"
        }
        else {
            self.language = "vi"
        }
        
        tfTitle.placeholder = "TITLE".localized(lang: language!)
        btnSaveOutlet.title = "DONE".localized(lang: language!)
        scImportantOutlet.setTitle("YES".localized(lang: language!), forSegmentAt: 0)
        scImportantOutlet.setTitle("NO".localized(lang: language!), forSegmentAt: 1)
        btnStartOutlet.setTitle("DEFAULT_START".localized(lang: language!), for: .normal)
        btnEndOutlet.setTitle("DEFAULT_END".localized(lang: language!), for: .normal)
    }
    
    func repeatDayToString(from ranges: [Int]) -> String {
        var result = ""
        let sorted = ranges.sorted()
        
        if sorted.count == 7 {
            return "Every day"
        }
        else if sorted.count > 0 {
            for i in 0..<sorted.count {
                if sorted[i] == 0 { result += "Mon".localized(lang: language!) + " "  }
                else if sorted[i] == 1 { result += "Tue".localized(lang: language!) + " " }
                else if sorted[i] == 2 { result += "Wed".localized(lang: language!) + " "  }
                else if sorted[i] == 3 { result += "Thu".localized(lang: language!) + " " }
                else if sorted[i] == 4 { result += "Fri".localized(lang: language!) + " " }
                else if sorted[i] == 5 { result += "Sat".localized(lang: language!) + " "  }
                else if sorted[i] == 6 { result += "Sun".localized(lang: language!) + " " }
            }
            return result
        }
        else {
            return "Never"
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showStartPicker" {
            let hoursNav = segue.destination as! UINavigationController
            let hoursPicker = hoursNav.topViewController as! PickerVC
            
            hoursPicker.currentSelectedValue = pickedHoursStart
            hoursPicker.presentationType = PickerVC.PresentationType.hoursStart(0, 0)
            hoursPicker.updateSelectedValue = { (newSelectedValue) in
                self.pickedHoursStart = newSelectedValue
                
                self.btnStartOutlet.setTitle("STARTS".localized(lang: self.language!) + "     \(self.pickedHoursStart!)", for: .normal)
                
                self.tableView.reloadData()
                
                guard let start = self.minuteth(from: self.btnStartOutlet.title(for: .normal)!) else {
                    return
                }
                
                guard let end = self.minuteth(from: self.btnEndOutlet.title(for: .normal)!) else {
                    return
                }
                
                if start <= 0 || end <= 0 {
                    self.btnSaveOutlet.isEnabled = false
                }
                else {
                    self.btnSaveOutlet.isEnabled = true
                }
            }
        }
        else if segue.identifier == "showEndPicker" {
            let hoursNav = segue.destination as! UINavigationController
            let hoursPicker = hoursNav.topViewController as! PickerVC
            
            hoursPicker.currentSelectedValue = pickedHoursEnd
            hoursPicker.presentationType = PickerVC.PresentationType.hoursEnd(0, 0)
            hoursPicker.updateSelectedValue = { (newSelectedValue) in
                self.pickedHoursEnd = newSelectedValue
                
                self.btnEndOutlet.setTitle("ENDS".localized(lang: self.language!) + "     \(self.pickedHoursEnd!)", for: .normal)
                
                self.tableView.reloadData()
                
                guard let start = self.minuteth(from: self.btnStartOutlet.title(for: .normal)!) else {
                    return
                }
                
                guard let end = self.minuteth(from: self.btnEndOutlet.title(for: .normal)!) else {
                    return
                }
                
                if start <= 0 || end <= 0 {
                    self.btnSaveOutlet.isEnabled = false
                }
                else {
                    self.btnSaveOutlet.isEnabled = true
                }
            }
        }
            /*
        else if segue.identifier == "showRepeatDay" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! DayRepeatPickerTVC
            
            if let repeatDay = pickedRepeatDay {
                if repeatDay.count > 0 {
                    pickedRepeatDay = pickedRepeatDay?.sorted()
                    vc.repeatDay = pickedRepeatDay
                }
            }
        }*/
        

        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === btnSaveOutlet else {
            Logger.verbose("The save button was not pressed, cancelling")
            return
        }
        
        let title = tfTitle.text ?? ""
        
        if let pickedDays = self.pickedDays {
            
            if self.pickedDays?.count != 0 {
                if let start = minuteth(from: btnStartOutlet.title(for: .normal)!) {
                    Logger.verbose("Haven't set start")
                    if scImportantOutlet.selectedSegmentIndex == 0 {
                        if start == -1 || start == 0 { return }
                    }
                    
                    if let end = minuteth(from: btnEndOutlet.title(for: .normal)!) {
                        
                        if end > start || scImportantOutlet.selectedSegmentIndex == 1 {
                            Logger.verbose("Haven't set end")
                            if scImportantOutlet.selectedSegmentIndex == 0 {
                                if end == -1 || end == 0 { return }
                            }
                            
                            let color = pickedColor!
                            let body = tvBody.text
                            
                            userDefaults.setValue(true, forKey: defaultsKeys.shouldReSchedule)
                            
                            userDefaults.synchronize()
                            
                            if scImportantOutlet.selectedSegmentIndex == 0 {
                                mission = Mission(title: title, body: body, length: 0, color: color, repeatDay: pickedDays, start: start, end: end, prioritized: true, isDone: false, caculated: true, morning: true, afternoon: true, night: true)
                            }
                            else {
                                mission = Mission(title: title, body: body, length: Int(sliderOutlet.value), color: color, repeatDay: pickedDays, start: 0, end: 0, prioritized: false, isDone: false, caculated: true, morning: isMorning, afternoon: isAfternoon, night: isNight)
                            }
                            
                            addMissionDelegate?.missionDidAdd(self)
                        }
                        else {
                            warning()
                            return
                        }
                    }
                    else {
                        warning()
                        return
                    }
                }
                else {
                    warning()
                    return
                }
            }
            else {
                warning()
                return
            }

        }
        else {
            warning()
            return
        }
        
        if let savedWeekCollection = loadWeek() {
            missions.removeAll()
            self.weekCollection = savedWeekCollection
            
            for i in 0..<weekCollection.count {
                for j in 0..<weekCollection[i].count {
                    missions += [weekCollection[i][j]]
                }
            }
            
            missions.append(mission!)
            
            //Filter same missions
            missions = Array(Set(missions))
            
            //Reset
            for i in 0..<weekCollection.count {
                self.weekCollection[i].removeAll()
            }
            
            for i in 0..<missions.count {
                for j in 0..<missions[i].repeatDay.count {
                    if weekCollection[safe: missions[i].repeatDay[j]] != nil {
                        weekCollection[missions[i].repeatDay[j]].append(missions[i])
                    }
                    else {
                        Logger.error("Error")
                    }
                }
            }
            
            missions.removeAll()
            
            for i in 0..<weekCollection.count {
                for j in 0..<weekCollection[i].count {
                    missions += [weekCollection[i][j]]
                }
            }
            
            saveWeek()
        }
        
    }
    
    func warning() {
        SCLAlertView().showError("NOT_COMPLETED!".localized(lang: language!), subTitle: "COMPLETE".localized(lang: language!))
        return
    }
    
    func minuteth(from string: String) -> Int? {
        let newStr = string.replacingOccurrences(of: "STARTS".localized(lang: language!) + "     ", with: "").replacingOccurrences(of: "ENDS".localized(lang: language!) + "     ", with: "")
        
        guard let hour = Int(newStr[0...1]) else { return -1 }
        
        guard let minute = Int(newStr[3...4]) else { return -1 }
        
        return (hour * 60 + minute) / 5
    }
}

