//
//  HeadFootHelper.swift
//  TimeBot
//
//  Created by QUANG on 4/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension InfoTVC {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "PROGRESS_HEADER".localized(lang: language!)
        case 1:
            return "EMAIL"
        case 2:
            return "DATA_HEADER".localized(lang: language!)
        case 3:
            return "SETTINGS_HEADER".localized(lang: language!)
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 3:
            return "SETTINGS_FOOTER".localized(lang: language!)
        default:
            return ""
        }
    }
}
