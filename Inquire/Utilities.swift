//
//  passwordUtilities.swift
//  Inquire
//
//  Created by Kevin Lu on 7/28/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    static func isPasswordValid(_ password:String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func createAlertController(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in alert.dismiss(animated: true, completion: nil)}
        alert.addAction(okAction)
        print("e")
        return alert
    }
}
