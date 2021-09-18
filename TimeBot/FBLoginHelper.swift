//
//  FBLoginHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/13/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

//import FBSDKLoginKit
/*
extension HomeVC: FBSDKLoginButtonDelegate {
    
    
    func setupFBLoginButton() {
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with Facebook...")
        
        self.firebaseLogin()
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, first_name, cover, last_name, age_range, link, gender, locale, picture"]).start { (connection, result, error) in
            if error != nil {
                print("Failed to start graph request", error!)
                return
            }
            
            print(result!)
        }
    }
}*/
