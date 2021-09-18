//
//  AppStateObserverHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/24/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension HomeVC {
    func setupObserver() {
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: Notification.Name.UIApplicationWillTerminate, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    func appMovedToBackground() {
        print("App moved to background!")
        saveWeek()
    }
    
    func appWillTerminate() {
        print("App will be terminated soon to!")
        saveWeek()
    }
}
