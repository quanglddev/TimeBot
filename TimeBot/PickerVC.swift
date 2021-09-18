//
//  PickerVC.swift
//  TimeBot
//
//  Created by QUANG on 3/20/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

import UIKit
import PickerView
import ChameleonFramework

class PickerVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet var picker: PickerView!
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if let updateValue = updateSelectedValue, let currentSelected = currentSelectedValue {
            updateValue(currentSelected)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Properties
    
    enum PresentationType {
        case hoursStart(Int, Int), hoursEnd(Int, Int) // NOTE: (Int, Int) represent the rawValue's of PickerView style enums.
    }
    
    let hoursStart: [String] = {
        var minuteths = [String]()
        
        for index in 1..<288 {
            let totalMinute = index * 5
            let hour = totalMinute / 60
            let minute = totalMinute % 60
            minuteths.append(String(format: "%02d:%02d", hour, minute))
        }
        
        return minuteths
    }()
    
    let hoursEnd: [String] = {
        var minuteths = [String]()
        
        for index in 1..<288 {
            let totalMinute = index * 5
            let hour = totalMinute / 60
            let minute = totalMinute % 60
            minuteths.append(String(format: "%02d:%02d", hour, minute))
        }
        
        return minuteths
    }()
    
        
    var presentationType = PresentationType.hoursStart(0, 0)

    var currentSelectedValue: String?
    var updateSelectedValue: ((_ newSelectedValue: String) -> Void)?
    
    //MARK: Default
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configurePicker()
    }

    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    fileprivate func configurePicker() {
        picker.dataSource = self
        picker.delegate = self
        
        let scrollingStyle: PickerView.ScrollingStyle
        let selectionStyle: PickerView.SelectionStyle
        
        switch presentationType {
        case let .hoursStart(scrollingStyleRaw, selectionStyleRaw):
            scrollingStyle = PickerView.ScrollingStyle(rawValue: scrollingStyleRaw)!
            selectionStyle = PickerView.SelectionStyle(rawValue: selectionStyleRaw)!
            
            picker.scrollingStyle = scrollingStyle
            picker.selectionStyle = selectionStyle
            
            if let currentSelected = currentSelectedValue, let indexOfCurrentSelectedValue = hoursStart.index(of: currentSelected) {
                picker.currentSelectedRow = indexOfCurrentSelectedValue
            }
        case let .hoursEnd(scrollingStyleRaw, selectionStyleRaw):
            scrollingStyle = PickerView.ScrollingStyle(rawValue: scrollingStyleRaw)!
            selectionStyle = PickerView.SelectionStyle(rawValue: selectionStyleRaw)!
            
            picker.scrollingStyle = scrollingStyle
            picker.selectionStyle = selectionStyle
            
            if let currentSelected = currentSelectedValue, let indexOfCurrentSelectedValue = hoursEnd.index(of: currentSelected) {
                picker.currentSelectedRow = indexOfCurrentSelectedValue
            }
        }
    }


    //MARK: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension PickerVC: PickerViewDataSource {
    // MARK: - PickerViewDataSource
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        switch presentationType {
        case .hoursStart(_, _):
            return hoursStart.count
        case .hoursEnd(_, _):
            return hoursEnd.count
        }
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        switch presentationType {
        case .hoursStart(_, _):
            return hoursStart[index]
        case .hoursEnd(_, _):
            return hoursEnd[index]
        }
    }
}

extension PickerVC: PickerViewDelegate {
    
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 50.0
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        switch presentationType {
        case .hoursStart(_, _):
            currentSelectedValue = hoursStart[index]
        case .hoursEnd(_, _):
            currentSelectedValue = hoursEnd[index]
        }
        
        print(currentSelectedValue ?? "No value selected")
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            if (highlighted) {
                label.font = UIFont.systemFont(ofSize: 26.0, weight: UIFontWeightLight)
            } else {
                label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightLight)
            }
        } else {
            if (highlighted) {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
            } else {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 26.0)
            }
        }
        
        if (highlighted) {
            label.textColor = view.tintColor
        } else {
            label.textColor = UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        }
    }
}
