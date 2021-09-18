//
//  HeaderFooterHelper.swift
//  TimeBot
//
//  Created by QUANG on 4/1/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension AddMissionTVC {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {/*
        case 0:
            return "DAY".localized(lang: language!)*/
        case 1:
            return "IMPORTANT".localized(lang: language!)
        case 2:
            if scImportantOutlet.selectedSegmentIndex == 0 {
                return ""
            }
            return "DURATION".localized(lang: language!)
        case 3:
            return "DESCRIPTION".localized(lang: language!)
        default:
            return ""
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "DAY_FOOTER".localized(lang: language!)
        case 1:
            return "IMPORTANT_FOOTER".localized(lang: language!)
        default:
            return ""
        }
    }*/
}
