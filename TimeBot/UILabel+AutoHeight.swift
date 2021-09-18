//
//  UILabel+AutoHeight.swift
//  TimeBot
//
//  Created by QUANG on 3/19/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension UILabel {
    
    func requiredHeight() -> CGFloat {
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}
