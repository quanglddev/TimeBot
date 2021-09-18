//
//  ArrayContainsArray.swift
//  TimeBot
//
//  Created by QUANG on 3/29/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit

extension HomeVC {
    func containsAll(father: [Int], son: [Int]) -> Bool {
        if son.isEmpty { return true }
        
        if son.count > father.count { return false }
        
        for element in son {
            if !father.contains(element) {
                return false
            }
        }
        
        return true
    }
    
    func containsAny(father: [Int], son: [Int]) -> Bool {
        if son.isEmpty || father.isEmpty { return true }
        
        for element in son {
            if father.contains(element) {
                return true
            }
        }
        
        return false
    }
}
