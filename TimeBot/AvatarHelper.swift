//
//  AvatarHelper.swift
//  TimeBot
//
//  Created by QUANG on 3/13/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension HomeVC {
    func setupAvatar() {
        self.avatarImageOutlet.layer.cornerRadius = self.avatarImageOutlet.frame.height / 2
        self.avatarImageOutlet.isUserInteractionEnabled = true
    }
}
