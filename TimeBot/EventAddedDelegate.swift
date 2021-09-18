//
//  EventAddedDelegate.swift
//  TimeBot
//
//  Created by QUANG on 3/22/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

protocol EventAddedDelegate {
    func eventDidAdd()
}

import UIKit

extension HomeVC: EventAddedDelegate {
    // MARK: Event Added Delegate
    func eventDidAdd() {
        //Call every time an event is added
        print("An event has been added!")
    }
}
