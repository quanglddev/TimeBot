//
//  StringExtension.swift
//  TimeBot
//
//  Created by QUANG on 4/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension String {
    
    func localized(lang: String) -> String {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
}
