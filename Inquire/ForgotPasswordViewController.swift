//
//  ForgotPasswordViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 8/10/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var errorMessage: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendButton.layer.cornerRadius = 15
        //cbutton.layer.borderWidth = 1
        //cbutton.layer.borderColor = UIColor.lightGray.cgColor
    }
/*
    @IBOutlet weak var cbutton: UIButton!
   
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }*/
    @IBAction func sendButtonPressed(_ sender: Any) {
        let auth = Auth.auth()

        auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if let error = error {
                self.errorMessage.text = error.localizedDescription
                self.errorMessage.alpha = 1
            } else {
                let alert = Utilities.createAlertController(title: "Done", message: "A password reset email has been sent")
                self.present(alert, animated: true, completion: nil)

            }


        }
    }
}
