//
//  LoginVC.swift
//  TimeBot
//
//  Created by QUANG on 3/27/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    let userDefaults = UserDefaults.standard
    
    struct defaultsKeys {
        static let emailAddress = "emailAddress"
        static let name = "name"
        static let avatar = "avatar"
        static let isEnglish = "isEnglish"
        static let isFirstLaunch = "isFirstLaunch"
    }
    
    
    var language: String?
    
    //MARK: Outlets
    
    @IBOutlet var btnLoginOutlet: UIButton!
    @IBOutlet var lblName: UITextField!
    @IBOutlet var lblEmail: UITextField!
    @IBOutlet var avatarImage: BFImageView!
    
    @IBOutlet var lblWelcome: UILabel!
    @IBOutlet var lblBody: UILabel!
    @IBOutlet var lblFullName: UILabel!
    @IBOutlet var lblCensor: UILabel!
    //MARK: Actions
    
    @IBAction func login(_ sender: UIButton) {
        if self.isEmail() && self.isNamed() {
            self.userDefaults.set(self.lblEmail.text, forKey: defaultsKeys.emailAddress)
            self.userDefaults.set(self.lblName.text, forKey: defaultsKeys.name)
            
            if let image = self.avatarImage.image {
                self.userDefaults.set(UIImagePNGRepresentation(image), forKey: defaultsKeys.avatar)
            }
            
            self.userDefaults.synchronize()
            
            self.toHomcVC()
        }
        else {
            self.showError()
        }
    }
    
    //MARK: Default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.needsBetterFace = true
        
        let isEnglish = userDefaults.bool(forKey: defaultsKeys.isEnglish)
        
        if isEnglish {
            self.language = "en"
        }
        else {
            self.language = "vi"
        }
        
        lblWelcome.text = "WELCOME".localized(lang: language!)
        lblBody.text = "BODY".localized(lang: language!)
        lblFullName.text = "FULL_NAME".localized(lang: language!)
        lblCensor.text = "CENSOR".localized(lang: language!)
        self.btnLoginOutlet.setTitle("DONE".localized(lang: self.language!), for: .normal)
        self.lblName.placeholder = "TYPE_NAME".localized(lang: self.language!)
        self.lblEmail.placeholder = "TYPE_MAIL".localized(lang: self.language!)
        
        
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.height / 2
        self.avatarImage.clipsToBounds = true
        self.btnLoginOutlet.layer.cornerRadius = 10
        self.avatarImage.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImageFromPhotoLibrary(_:)))
        
        self.avatarImage.addGestureRecognizer(tap)
        
        lblEmail.delegate = self
        lblName.delegate = self
        
        let email = userDefaults.string(forKey: defaultsKeys.emailAddress)
        let name = userDefaults.string(forKey: defaultsKeys.name)
        
        
        guard let savedEmail = email else {
            return
        }
        
        guard let savedName = name else {
            return
        }
        
        lblEmail.text = savedEmail
        lblName.text = savedName
        
        if let avatarData = userDefaults.data(forKey: defaultsKeys.avatar) {
            let image = UIImage(data: avatarData)
            if let image = image {
                avatarImage.image = image
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        
        let isFirstLaunch = userDefaults.bool(forKey: defaultsKeys.isFirstLaunch)
        
        if !isFirstLaunch {
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("English") {
                self.userDefaults.set(true, forKey: defaultsKeys.isEnglish)
                
                self.userDefaults.synchronize()
                
                self.language = "en"
                
                DispatchQueue.main.async {
                    self.lblWelcome.text = "WELCOME".localized(lang: self.language!)
                    self.lblBody.text = "BODY".localized(lang: self.language!)
                    self.lblFullName.text = "FULL_NAME".localized(lang: self.language!)
                    self.lblCensor.text = "CENSOR".localized(lang: self.language!)
                    self.btnLoginOutlet.setTitle("DONE".localized(lang: self.language!), for: .normal)
                    self.lblName.placeholder = "TYPE_NAME".localized(lang: self.language!)
                    self.lblEmail.placeholder = "TYPE_MAIL".localized(lang: self.language!)
                    
                    self.userDefaults.set(true, forKey: defaultsKeys.isFirstLaunch)
                    
                    self.userDefaults.synchronize()
                }
            }
            alertView.addButton("Tiếng Việt") {
                self.userDefaults.set(false, forKey: defaultsKeys.isEnglish)
                
                self.userDefaults.synchronize()
                
                self.language = "vi"
                
                DispatchQueue.main.async {
                    self.lblWelcome.text = "WELCOME".localized(lang: self.language!)
                    self.lblBody.text = "BODY".localized(lang: self.language!)
                    self.lblFullName.text = "FULL_NAME".localized(lang: self.language!)
                    self.lblCensor.text = "CENSOR".localized(lang: self.language!)
                    self.btnLoginOutlet.setTitle("DONE".localized(lang: self.language!), for: .normal)
                    self.lblName.placeholder = "TYPE_NAME".localized(lang: self.language!)
                    self.lblEmail.placeholder = "TYPE_MAIL".localized(lang: self.language!)
                    
                    self.userDefaults.set(true, forKey: defaultsKeys.isFirstLaunch)
                    
                    self.userDefaults.synchronize()
                }
            }
            alertView.showSuccess("CHOOSE", subTitle: "CHOOSE YOUR LANGUAGE")
            /*
             let alertController = UIAlertController(title: "CHOOSE", message: "CHOOSE YOUR LANGUAGE", preferredStyle: .alert)
             
             let cancelAction = UIAlertAction(title: "English", style: .cancel) { (action: UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Tiếng Việt", style: .default) { (action: UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)*/
        }
    }
    
    func isNamed() -> Bool {
        if (lblName.text?.isEmpty)! {
            return false
        }
        else {
            return true
        }
    }
    
    func isEmail() -> Bool {
        if (lblEmail.text?.isEmpty)! {
            return false
        }
        else {
            if (lblEmail.text?.contains("@"))! {
                return true
            }
            else {
                return false
            }
        }
    }
    
    func showError() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK") {
        }
        alertView.showError("Invalid", subTitle: "CREDENTIAL".localized(lang: language!))
    }
    
    func toHomcVC() {
        //Open Info View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UINavigationController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        lblName.resignFirstResponder()
        lblEmail.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        avatarImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
