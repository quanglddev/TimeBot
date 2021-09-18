//
//  TextInputHandler.swift
//  TimeBot
//
//  Created by QUANG on 3/20/17.
//  Copyright © 2017 QUANG INDUSTRIES. All rights reserved.
//

extension AddMissionTVC: UITextFieldDelegate, UITextViewDelegate {
    
    func setupTextInput() {
        // Handle the text field’s user input through delegate callbacks.
        tfTitle.delegate = self
        tvBody.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
