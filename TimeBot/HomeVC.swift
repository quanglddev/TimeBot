//
//  ViewController.swift
//  TimeBot
//
//  Created by QUANG on 3/9/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
//import GoogleSignIn
import EventKit
import EventKitUI
import ChameleonFramework
import SCLAlertView
import UserNotifications
import Dotzu
import Device

let reuseWeekdayCVCIdentifier = "WeekdayCVCell"
let reuseMissionCVCIdentifier = "MissionCVCell"

class HomeVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Properties    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    var delegate: EventAddedDelegate?
        
    var weekCollection = [[Mission]]()
    var used = [Int]()
    
    var selectedIndexPath: IndexPath?
    let customFont = UIFont(name: "Helvetica", size: 17.0)
    
    var index: Int = 0
    
    let userDefaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let shouldReSchedule = "shouldReSchedule"
        static let picture = "picture"
        static let areAllBeAlert = "shouldAllBeAlert"
        static let emailAddress = "emailAddress"
        static let name = "name"
        static let avatar = "avatar"
        static let isEnglish = "isEnglish"
        static let countNoti = "countNoti"
    }
    
    let notificationCenter = NotificationCenter.default
        
    var language: String?
    
    let morning: [Int] = Array(0...144)
    let afternoon: [Int] = Array(145...216)
    let night: [Int] = Array(217...288)
    
    var cellShown = [[Bool]]()
    
    //MARK: Outlets
    @IBOutlet var avatarImageOutlet: BFImageView!
    @IBOutlet var lblWeekday: UITextField!
    @IBOutlet var weekTableView: UITableView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNoContent: UILabel!
    @IBOutlet var btnResetNotiOutlet: UIBarButtonItem!
    
    
    //MARK: Defaults
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageOutlet.needsBetterFace = true
        
        let isEnglish = userDefaults.bool(forKey: defaultsKeys.isEnglish)
        
        if isEnglish {
            self.language = "en"
        }
        else {
            self.language = "vi"
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        if let savedWeek = loadWeek() {
            weekCollection = savedWeek
            if weekCollection.isEmpty {
                weekCollection = [[Mission](), [Mission](), [Mission](), [Mission](), [Mission](), [Mission](), [Mission]()]
            }
        }
        else{
            // Load the sample data.
            //loadSampleWeek()
            weekCollection = [[Mission](), [Mission](), [Mission](), [Mission](), [Mission](), [Mission](), [Mission]()]
        }
        
        setupAvatar()
        
        //Automatic scroll to current date
        
        //saveWeek()
        
        weekTableView.layer.cornerRadius = 15.0
        weekTableView.layer.shadowRadius = 10
        weekTableView.layer.shadowOpacity = 0.4
        weekTableView.layer.shadowOffset = CGSize(width: 5, height: 10)
        weekTableView.layer.borderWidth = 1
        weekTableView.layer.borderColor = RandomFlatColor().cgColor
        
        /*
        setupCalendar(completion: {_ in 
            if self.userDefaults.bool(forKey: defaultsKeys.shouldReSchedule) {
                var calendarIdentifier = ""
                
                let calendars :[EKCalendar] = self.eventStore.calendars(for: EKEntityType.event)
                for aCal in calendars
                {
                    if aCal.title == "TimeBot" {
                        calendarIdentifier = aCal.calendarIdentifier
                        //break
                    }
                    print(aCal.title)
                }
                
                if self.eventStore.calendar(withIdentifier: calendarIdentifier) != nil {
                    //self.deleteEvents()
                    self.scheduleMissions()
                    self.organizeMissions()
                    //self.setupEvents()
                }
            }
        })*/
        
        //self.deleteEvents()
        //self.setupEvents()
        
        if !self.userDefaults.bool(forKey: defaultsKeys.shouldReSchedule) {
            
            self.scheduleMissions()
            self.organizeMissions()
            self.setNotificationForWeek()
            self.organizeByDone()
            
            self.userDefaults.set(true, forKey: defaultsKeys.shouldReSchedule)
            
            self.userDefaults.synchronize()
        }
        
        var count = 0
        var countDone = 0
        cellShown.removeAll()
        
        var tempCell = [Bool]()
        
        for i in 0..<weekCollection.count {
            
            tempCell.removeAll()
            
            for j in 0..<weekCollection[i].count {
                count += 1
                if weekCollection[i][j].isDone {
                    countDone += 1
                }
                
                tempCell.append(false)
            }
            
            cellShown.append(tempCell)
        }
        Logger.verbose("Total missions: \(count)")
        Logger.verbose("Total countDone: \(countDone)")
        
        setupObserver()
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        longPressed.minimumPressDuration = 0.5
        longPressed.delaysTouchesBegan = true
        longPressed.delegate = self
        self.weekTableView.addGestureRecognizer(longPressed)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarTapped(_:)))
        avatarImageOutlet.addGestureRecognizer(tap)
        
        loadUserInfo()
        
        organizeMissions()
        
        lblWeekday.text = "HOME".localized(lang: language!)
        lblNoContent.text = "TABLE_EMPTY".localized(lang: language!)
        
        #if DEBUG
            if Device.version() == .iPhone5S {
                btnResetNotiOutlet.isEnabled = true
            }
            else {
                btnResetNotiOutlet.isEnabled = false
            }
        #else
            btnResetNotiOutlet.isEnabled = false
        #endif
    }
    
    func loadUserInfo() {
        let name = userDefaults.string(forKey: defaultsKeys.name)
        lblName.text = name
        
        if let avatarData = userDefaults.data(forKey: defaultsKeys.avatar) {
            let image = UIImage(data: avatarData)
            if let image = image {
                avatarImageOutlet.image = image
            }
        }
    }
    
    func avatarTapped(_ sender: UITapGestureRecognizer) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("EDIT".localized(lang: language!)) {
            self.toLogin()
        }
        alertView.addButton("CANCEL".localized(lang: language!), action: {
            //Ignore
        })
        alertView.showSuccess("PERSONALIZE_INFO".localized(lang: language!), subTitle: "CHANGE".localized(lang: language!))
    }
    
    func toLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        present(controller, animated: true, completion: nil)
        
        //performSegue(withIdentifier: "ToLogin", sender: self)
    }
    
    func handleForceTouch(sender: UIForceTouchCapability) {
        
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        var shouldShow = false
        
        if gestureReconizer.state != .began {
            return
        }
        
        let p = gestureReconizer.location(in: self.weekTableView)
        let indexPath = self.weekTableView.indexPathForRow(at: p)
        
        if let index = indexPath {
            //let header = weekTableView.headerView(forSection: index.section)
            let alertView = SCLAlertView()
            for mission in weekCollection[index.section] {
                if mission.start == 0 {
                    shouldShow = true
                    alertView.addButton(mission.title + " - \(durationLengthFrom(minuteth: mission.length))") {
                    }
                }
            }
            
            if shouldShow {
                alertView.showInfo("XXX".localized(lang: language!), subTitle: "XXXXXXXXXX")
            }
            
            print("Section: \(index.section), row: \(index.row)")
        } else {
            print("Could not find index path")
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        
        scrollToToday()
        
        checkContent()
    }
    
    func checkContent() {
        var count = 0
        for day in weekCollection {
            for _ in day {
                count += 1
            }
        }
        
        if count == 0 {
            self.lblNoContent.fadeIn()
            self.weekTableView.fadeOut()
            self.weekTableView.isHidden = true
            self.lblNoContent.isHidden = false
        }
        else {
            self.weekTableView.fadeIn()
            self.lblNoContent.fadeOut()
            self.lblNoContent.isHidden = true
            self.weekTableView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setupEventKit()
    }
    
    //MARK: Actions
    @IBAction func unwindToHomeVCList(segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? AddMissionTVC, let mission = sourceViewController.mission {
            
            if let isEditing = sourceViewController.isEditingMission {
                if isEditing {
                    //This code checks whether a row in the table view is selected. If it is, that means a user tapped one of the table views cells to edit a task. In other words, this if statement gets executed when you are editing an existing task.
                    // Update an existing task
                    
                    let thingToDelete = mission.title
                    for i in 0..<weekCollection.count {
                        for j in 0..<weekCollection[i].count {
                            if weekCollection[i][j].title == thingToDelete {
                                //weekTableView.deleteRows(at: [IndexPath(row: j, section: j)], with: .fade)
                                weekCollection[i][j] = mission
                                break
                            }
                        }
                    }
                }
            }
            else {
                // Add a new task.
                var newIndexPath = [IndexPath]()
                newIndexPath.removeAll()
                
                for i in 0..<mission.repeatDay.count {
                    newIndexPath += [IndexPath(row: weekCollection[mission.repeatDay[i]].count, section: mission.repeatDay[i])]
                    
                    let newRepeatDay = mission.repeatDay[i]
                    let newMissionWithNewRepeatDay = Mission(title: mission.title, body: mission.body, length: mission.length, color: mission.color, repeatDay: mission.repeatDay, start: mission.start, end: mission.end, prioritized: mission.prioritized, isDone: mission.isDone, caculated: false, morning: mission.morning, afternoon: mission.afternoon, night: mission.night)!
                    weekCollection[mission.repeatDay[i]].append(newMissionWithNewRepeatDay)
                }
                
                weekTableView.insertRows(at: newIndexPath, with: .automatic)
            }
            
            //Reschedule every time a mission is added
            /*setupCalendar(completion: {_ in
             if self.userDefaults.bool(forKey: defaultsKeys.shouldReSchedule) {
             if self.eventStore.calendar(withIdentifier: "TimeBotCalendar") != nil {
             //self.deleteEvents()
                        self.scheduleMissions()
                        self.organizeMissions()
                        //self.setupEvents()
                    }
                }
            })*/
            
            self.scheduleMissions()
            self.organizeMissions()
            self.setNotificationForWeek()
            self.organizeByDone()
            
            weekTableView.reloadData()
        }
        saveWeek()
    }
    
    
    @IBAction func btnResetNotification(_ sender: UIBarButtonItem) {
        #if DEBUG
            self.setNotificationForWeek()
        #endif
    }
    
    
    @IBAction func btnRefresh(_ sender: UIBarButtonItem) {
        self.scheduleMissions()
        self.organizeMissions()
        self.setNotificationForWeek()
        self.organizeByDone()
        self.saveWeek()
        
        DispatchQueue.main.async {
            self.weekTableView.reloadData()
        }
    }
    
    @IBAction func btnSettingsOutlet(_ sender: UIBarButtonItem) {
        
        pictureTable()
        
        //Open Info View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: "InfoTVC") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            print("Adding a new mission.")
        case "ShowDetail":
            guard let missionDetailViewController = segue.destination as? AddMissionTVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTaskCell = sender as? MissionTVCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = weekTableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMission = weekCollection[indexPath.section][indexPath.row]
            
            missionDetailViewController.mission = selectedMission
        case "toInfoTVC":
            print("Settings")
        case "ToLogin":
            print("Edit personal info.")
        default:
            Logger.error("Unexpected Segue Identifier: \(segue.identifier)")
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
        }
    }
    
    func pictureTable() {
        //let image = UIImage(view: weekTableView)
        let image = weekTableView.screenshot
        
        if let image = image {
            userDefaults.set(UIImagePNGRepresentation(image), forKey: defaultsKeys.picture)
            
            userDefaults.synchronize()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = weekCollection[safe: section] {
            return rows.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var total = 0
        var caculated = 0
        
        for mission in weekCollection[section] {
            total += 1
            if mission.start != 0 {
                caculated += 1
            }
        }
        
        let result = " (\(caculated)/\(total))"
        
        if section == 0 { return "MONDAY_WEEKDAY".localized(lang: language!) + result}
        else if section == 1 { return "TUESDAY_WEEKDAY".localized(lang: language!) + result}
        else if section == 2 { return "WEDNESDAY_WEEKDAY".localized(lang: language!) + result }
        else if section == 3 { return "THURSDAY_WEEKDAY".localized(lang: language!) + result }
        else if section == 4 { return "FRIDAY_WEEKDAY".localized(lang: language!) + result }
        else if section == 5 { return "SATURDAY_WEEKDAY".localized(lang: language!) + result }
        else { return "SUNDAY_WEEKDAY".localized(lang: language!) + result }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        /*
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.contentView.backgroundColor = .black*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MissionTVCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MissionTVCell else {
            fatalError("The dequeued cell is not an instance of MissionTVCell.")
        }
        
        let mission = weekCollection[indexPath.section][indexPath.row]
        cell.mission = mission
        //cell.tag = Int("\(indexPath.section)\(indexPath.row)")!
        //print("\(indexPath.section)\(indexPath.row)")
        //cell.delegate = self
        //mission.tag = Int("\(indexPath.section)\(indexPath.row)")!
        cell.cbDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: .fade)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MissionTVCell).watchFrameChanges()
        
        guard cellShown[safe: indexPath.section] != nil else {
            return
        }
        
        guard cellShown[indexPath.section][safe: indexPath.row] != nil else {
            return
        }
        
        if !cellShown[indexPath.section][indexPath.row] {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.5, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
            
            cellShown[indexPath.section][indexPath.row] = true
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! MissionTVCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if weekCollection[indexPath.section][indexPath.row].start == 0 {
            return 0
        }
        
        if indexPath == selectedIndexPath {
            return MissionTVCell.defaultHeight + 18 + heightForView(text: "00 00 - 00 00" + "\n\n" + weekCollection[indexPath.section][indexPath.row].body!, font: customFont!, width: weekTableView.frame.width - 32)
        }
        else {
            return MissionTVCell.defaultHeight
        }
    }
    
    func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAll = UITableViewRowAction(style: .normal, title: "DELETE_ALL".localized(lang: language!)) { (action, indexPath) in
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("YES".localized(lang: self.language!)){
                
                let thingsToDelete = self.weekCollection[indexPath.section][indexPath.row].title
                // Delete the row from the data source
                for i in 0..<self.weekCollection.count {
                    for j in 0..<self.weekCollection[i].count {
                        if self.weekCollection[i][j].title == thingsToDelete {
                            self.weekCollection[i].remove(at: j)
                            let indexPathToDelete = IndexPath(row: j, section: i)
                            tableView.deleteRows(at: [indexPathToDelete], with: .fade)
                            break
                            //SHould not break cause user might have multiple same mission and we don't want that
                        }
                    }
                }
                self.checkContent()
                self.saveWeek()
                
                self.scheduleMissions()
                self.organizeMissions()
                self.setNotificationForWeek()
                self.organizeByDone()
                
                self.weekTableView.reloadData()
            }
            alertView.addButton("NO".localized(lang: self.language!), action: {
                //Dismiss
            })
            alertView.showWarning("ARE_YOU_SURE".localized(lang: self.language!), subTitle: "DELETE_ALL_2".localized(lang: self.language!))
        }
        deleteAll.backgroundColor = UIColor.flatRed
        
        let delete = UITableViewRowAction(style: .normal, title: "DELETE".localized(lang: language!)) { (action, indexPath) in
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.addButton("YES".localized(lang: self.language!)){
                self.weekCollection[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.checkContent()
                self.saveWeek()
                
                self.scheduleMissions()
                self.organizeMissions()
                self.setNotificationForWeek()
                self.organizeByDone()
                
                self.weekTableView.reloadData()
            }
            alertView.addButton("NO".localized(lang: self.language!), action: {
                //Dismiss
            })
            alertView.showWarning("ARE_YOU_SURE".localized(lang: self.language!), subTitle: "DELETE_2".localized(lang: self.language!))
        }
        delete.backgroundColor = UIColor.flatGreen
        
        let edit = UITableViewRowAction(style: .normal, title: "EDIT".localized(lang: language!)) { (action, indexPath) in
            self.performSegue(withIdentifier: "ShowDetail", sender: self.weekTableView.cellForRow(at: indexPath))
        }
        edit.backgroundColor = UIColor.flatYellow
        
        return [edit, deleteAll, delete]
    }
}

extension HomeVC {
    func updateWeekday(index: Int) {
        DispatchQueue.main.async {
            switch index {
            case 0:
                self.lblWeekday.text = "MONDAY_WEEKDAY".localized(lang: self.language!)
            case 1:
                self.lblWeekday.text = "TUESDAY_WEEKDAY".localized(lang: self.language!)
            case 2:
                self.lblWeekday.text = "WEDNESDAY_WEEKDAY".localized(lang: self.language!)
            case 3:
                self.lblWeekday.text = "THURSDAY_WEEKDAY".localized(lang: self.language!)
            case 4:
                self.lblWeekday.text = "FRIDAY_WEEKDAY".localized(lang: self.language!)
            case 5:
                self.lblWeekday.text = "SATURDAY_WEEKDAY".localized(lang: self.language!)
            case 6:
                self.lblWeekday.text = "SUNDAY_WEEKDAY".localized(lang: self.language!)
            default:
                self.lblWeekday.text = "HELLO_WORLD".localized(lang: self.language!)
            }
        }
    }
}

extension HomeVC: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch  response.actionIdentifier {
        case "answerOK":
            let alert = UIAlertController(title: "GOOD_JOB".localized(lang: self.language!), message: "PRIZE".localized(lang: self.language!), preferredStyle: .alert)
            let action = UIAlertAction(title: "THANKS".localized(lang: self.language!), style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        default:
            Logger.error("error")
            break
        }
        UIApplication.shared.applicationIconBadgeNumber = 0 //Clear badges
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Some other way of handing notification in app
        completionHandler([.alert, .sound])
    }
}
