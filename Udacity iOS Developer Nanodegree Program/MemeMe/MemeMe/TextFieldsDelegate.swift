//
//  TextFieldsDelegate.swift
//  MemeMe
//
//  Created by Tongyu on 8/16/16.
//  Copyright © 2016 Tongyu Yang. All rights reserved.
//

import Foundation
import UIKit

class TextFieldsDelegate : NSObject, UITextFieldDelegate {
    
    // When a user taps inside a textfield, the default text should clear
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

    // When a user presses return, the keyboard should be dismissed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}