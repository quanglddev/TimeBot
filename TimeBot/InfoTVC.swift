//
//  InfoTVC.swift
//  TimeBot
//
//  Created by QUANG on 3/26/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import ChameleonFramework
import SCLAlertView
import Social
import MessageUI
import Photos
import Dotzu

class InfoTVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: Properties
    let userDefaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let picture = "picture"
        static let areAllBeAlert = "shouldAllBeAlert"
        static let emailAddress = "emailAddress"
        static let isEnglish = "isEnglish"
    }
    
    var weekCollection = [[Mission]]()
    
    var language: String?
    
    //MARK: Outlets
    
    @IBOutlet var niInfo: UINavigationItem!
    @IBOutlet var swAlarmForAllOutlet: UISwitch!
    @IBOutlet var lblTodayPerformance: UILabel!
    @IBOutlet var lblPerformance: UILabel!
    @IBOutlet var btnSaveOutlet: UIButton!
    @IBOutlet var btnClearOutlet: UIButton!
    @IBOutlet var btnPermissionOutlet: UIButton!
    @IBOutlet var btnLanguageOutlet: UIButton!
    @IBOutlet var lblAlarm: UILabel!
    
    //MARK: Actions
    @IBAction func `return`(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setLanguageAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("English") {
            self.userDefaults.set(true, forKey: defaultsKeys.isEnglish)
            
            self.userDefaults.synchronize()
            
            self.language = "en"
            
            DispatchQueue.main.async {
                self.lblPerformance.text = "PERFORMANCE".localized(lang: self.language!)
                self.btnSaveOutlet.setTitle("SAVE".localized(lang: self.language!), for: .normal)
                self.btnClearOutlet.setTitle("CLEAR_ALL".localized(lang: self.language!), for: .normal)
                self.btnPermissionOutlet.setTitle("PERMISSION".localized(lang: self.language!), for: .normal)
                self.btnLanguageOutlet.setTitle("LANGUAGE".localized(lang: self.language!), for: .normal)
                self.lblAlarm.text = "ALARM".localized(lang: self.language!)
                self.niInfo.title = "INFO".localized(lang: self.language!)
            }
        }
        alertView.addButton("Tiếng Việt") {
            self.userDefaults.set(false, forKey: defaultsKeys.isEnglish)
            
            self.userDefaults.synchronize()
            
            self.language = "vi"
            
            DispatchQueue.main.async {
                self.lblPerformance.text = "PERFORMANCE".localized(lang: self.language!)
                self.btnSaveOutlet.setTitle("SAVES".localized(lang: self.language!), for: .normal)
                self.btnClearOutlet.setTitle("CLEAR_ALL".localized(lang: self.language!), for: .normal)
                self.btnPermissionOutlet.setTitle("PERMISSION".localized(lang: self.language!), for: .normal)
                self.btnLanguageOutlet.setTitle("LANGUAGE".localized(lang: self.language!), for: .normal)
                self.lblAlarm.text = "ALARM".localized(lang: self.language!)
                self.niInfo.title = "INFO".localized(lang: self.language!)
            }
        }
        alertView.showSuccess("CHOOSE".localized(lang: language!), subTitle: "CHOOSE YOUR LANGUAGE")
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("FACEBOOK".localized(lang: language!)) {
            self.openFacebookComposer()
        }
        alertView.addButton("TWITTER".localized(lang: language!)) {
            self.openTwitterComposer()
        }
        alertView.addButton("CANCEL".localized(lang: language!), action: {
            //Ignore
        })
        alertView.showSuccess("SHARE".localized(lang: language!), subTitle: "CHOOSE".localized(lang: language!))
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        // Add a text field
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 216, height: 160))
        //let x = (subview.frame.width - 180) / 2
        
        // Add imageView
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 216, height: 160))
        imageView.layer.borderColor = UIColor.flatGreen.cgColor
        imageView.layer.borderWidth = 1.5
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        if let imageData = userDefaults.data(forKey: defaultsKeys.picture) {
            let image = UIImage(data: imageData)
            if let image = image {
                imageView.image = image
            }
            else {
                failedSendingMail()
                return
            }
        }
        else {
            failedSendingMail()
            return
        }
        subview.addSubview(imageView)
        // Add the subview to the alert's UI property
        alertView.customSubview = subview
        let txt = alertView.addTextField("EMAIL".localized(lang: language!))
        
        let email = userDefaults.string(forKey: defaultsKeys.emailAddress)
        txt.text = email
        txt.textAlignment = .center
        
        alertView.addButton("SEND".localized(lang: language!)) {
            Logger.verbose("Text value: \(txt.text)")
            
            //Check input
            guard let email = txt.text else {
                self.failedSendingMail()
                return
            }
            
            if email.isEmpty {
                self.failedSendingMail()
                return
            }
            
            //CHECK IF CAN SEND
            if MFMailComposeViewController.canSendMail() {
                var totalMissions = 0
                var doneMissions = 0
                for day in self.weekCollection {
                    for mission in day {
                        totalMissions += 1
                        if mission.isDone {
                            doneMissions += 1
                        }
                    }
                }
                
                if totalMissions != 0 {
                    let mailComposeViewController = self.configuredMailComposeViewController(recipient: email)
                    
                    if MFMailComposeViewController.canSendMail() {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                }
                else {
                    self.showSendMailErrorAlert()
                }
            }
        }
        alertView.addButton("SAVE".localized(lang: language!), action: {
            if self.isPhotoLibraryAuthorized() {
                self.saveImageToCamera()
            }
            else {
                self.requestPhotoLibrary()
            }
        })
        alertView.addButton("NEXT_TIME".localized(lang: language!)) {
            //Ignore
        }
        alertView.showEdit("SEND".localized(lang: language!), subTitle: "CONFIRM_SEND".localized(lang: language!))
    }
    
    
    @IBAction func clearAllData(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("RESET".localized(lang: language!)) {
            self.weekCollection = [[Mission]]()
            self.saveWeek()
        }
        alertView.addButton("NO".localized(lang: language!)) {
            //Ignore
        }
        alertView.showWarning("ARE_YOU_SURE".localized(lang: language!), subTitle: "ARE_YOU_SURE_2".localized(lang: language!), duration: 5)
    }
    
    @IBAction func toSettings(_ sender: UIButton) {
        let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func swAlarmForAllAction(_ sender: UISwitch) {
        swAlarmForAllOutlet.setOn(swAlarmForAllOutlet.isOn, animated: true)
        
        userDefaults.set(swAlarmForAllOutlet.isOn, forKey: defaultsKeys.areAllBeAlert)
        
        userDefaults.synchronize()
    }
    
    
    //MARK: Default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isEnglish = userDefaults.bool(forKey: defaultsKeys.isEnglish)
        
        if isEnglish {
            self.language = "en"
        }
        else {
            self.language = "vi"
        }
        
        lblPerformance.text = "PERFORMANCE".localized(lang: language!)
        btnSaveOutlet.setTitle("SAVES".localized(lang: language!), for: .normal)
        btnClearOutlet.setTitle("CLEAR_ALL".localized(lang: language!), for: .normal)
        btnPermissionOutlet.setTitle("PERMISSION".localized(lang: language!), for: .normal)
        btnLanguageOutlet.setTitle("LANGUAGE".localized(lang: language!), for: .normal)
        lblAlarm.text = "ALARM".localized(lang: language!)
        niInfo.title = "INFO".localized(lang: language!)
        
        if let savedWeekCollection = loadWeek() {
            weekCollection = savedWeekCollection
            
            var totalMissions = 0
            var doneMissions = 0
            for day in weekCollection {
                for mission in day {
                    totalMissions += 1
                    if mission.isDone {
                        doneMissions += 1
                    }
                }
            }
            
            if totalMissions != 0 {
            let percent: String = String(Int(floor(Double(doneMissions) / Double(totalMissions) * 100))) + "%" + " (\(doneMissions)/\(totalMissions))"
            lblTodayPerformance.text = percent
            }
            else {
                lblTodayPerformance.text = "NO_DATA".localized(lang: language!)
            }
        }
        
        let isOn = userDefaults.bool(forKey: defaultsKeys.areAllBeAlert)
        swAlarmForAllOutlet.setOn(isOn, animated: true)
    }
    
    func openFacebookComposer() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.setInitialText("SHARE_TEXT".localized(lang: language!))
            fbShare.add(UIImage(named: "AppIcon60x60"))
            self.present(fbShare, animated: true, completion: nil)
        } else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
            }
            alertView.showError("Accounts", subTitle: "Please login to a Facebook account to share.")
        }
    }
    
    func openTwitterComposer() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let tweetShare: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText("SHARE_TEXT".localized(lang: language!))
            tweetShare.add(UIImage(named: "AppIcon60x60"))
            self.present(tweetShare, animated: true, completion: nil)
        } else {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("OK") {
            }
            alertView.showError("Accounts", subTitle: "Please login to a Twitter account to tweet.")
        }
    }
    
    func configuredMailComposeViewController(recipient: String) -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([recipient])
        mailComposerVC.setSubject("MAIL_SUBJECT".localized(lang: language!) + " \(Date())")
        
        var totalMissions = 0
        var doneMissions = 0
        for day in weekCollection {
            for mission in day {
                totalMissions += 1
                if mission.isDone {
                    doneMissions += 1
                }
            }
        }
        
        if totalMissions != 0 {
            mailComposerVC.setMessageBody("MAIL_BODY".localized(lang: language!) + "(\(doneMissions)/\(totalMissions))", isHTML: false)
        }
        
        if let imageData = userDefaults.data(forKey: defaultsKeys.picture) {
            let image = UIImage(data: imageData)
            if let image = image {
                if let imageData = UIImagePNGRepresentation(image) {
                    mailComposerVC.addAttachmentData(imageData, mimeType: "image/png", fileName: "MAIL_ATTACH".localized(lang: language!) + "(\(Date()))")
                }
            }
        }
        
        return mailComposerVC
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showSendMailErrorAlert() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK") {
        }
        alertView.showError("MAIL_FAILED".localized(lang: language!), subTitle: "MAIL_FAILED_2".localized(lang: language!))
    }
    
    func isPhotoLibraryAuthorized() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            return true
        case .denied:
            return false
        case .notDetermined:
            return false
        default:
            return false
        }
    }
    
    func requestPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.saveImageToCamera()
            default:
                print()
            }
        }
    }
    
    func success() {
         let alertView = SCLAlertView()
         alertView.showSuccess("DONE".localized(lang: language!), subTitle: "SAVED".localized(lang: language!))
    }
    
    func saveImageToCamera() {
        
        if let imageData = self.userDefaults.data(forKey: defaultsKeys.picture) {
            let image = UIImage(data: imageData)
            if let image = image {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (success, error) in
                    if success {
                        Logger.verbose("Save successfully")
                        //UIApplication.shared.open(URL(string: "app-photos")!)
                        
                        let alert = UIAlertController(title: "DONE".localized(lang: self.language!), message: "SAVED".localized(lang: self.language!), preferredStyle: UIAlertControllerStyle.alert)
                        
                        let okBtn = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        
                        alert.addAction(okBtn)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if let error = error {
                        Logger.error("Faile to save: ", error)
                    }
                    else {
                        Logger.error("Weird")
                        // Save photo failed with no error
                    }
                })
            }
        }
        else {
            Logger.error("No image")
        }
    }
    
    func failedSendingMail() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK") {
        }
        alertView.showError("SEND_FAILED".localized(lang: language!), subTitle: "MISTYPED".localized(lang: language!))
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
