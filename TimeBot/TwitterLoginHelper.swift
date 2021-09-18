//
//  TwitterLoginHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/13/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

/*
import TwitterKit
import Firebase

extension HomeVC {
    func setupTwitterLoginButton() {
        let twitterButton = TWTRLogInButton { (session, error) in
            
            if let err = error {
                print("Failed to log in via Twitter", err)
                return
            }
            
            print("Successfully logged in via Twitter")
            
            guard let token = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            
            let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
            
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                if let err = error {
                    print("Failed to log in Firebase via Twitter...", err)
                    return
                }
                
                print("Successfully logged into Firebase via Twitter...", user?.uid ?? "None")
            })
        }
        
        view.addSubview(twitterButton)
        twitterButton.frame = CGRect(x: 16, y: 166 + 66 + 10, width: view.frame.width - 32, height: 50)
        
    }
}
*/
