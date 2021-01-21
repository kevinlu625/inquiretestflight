//
//  LogInViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 7/28/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var cbutton: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpElements()
            self.loginButton.layer.cornerRadius = 15
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        emailTextField.delegate = self
        //cbutton.layer.borderWidth = 1
        //cbutton.layer.borderColor = UIColor.lightGray.cgColor

            
        }
        
        func setUpElements() {
            errorLabel.alpha = 0
        }
        
    

    @IBAction func loginTapped(_ sender: Any) {
    
            //Validate text fields
            
            //Create cleaned version of the text fields
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let db = Firestore.firestore()
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
            if error != nil {
                    
                    //Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    UserData.currentChannel = "General"
                    self.transitionToHome()
                }
            }
        db.collection("users").whereField("email", isEqualTo: email).getDocuments(completion:
                {
                    (QuerySnapshot, Error) in
                    if let err = Error
                    {
                        print("Error getting documents: \(err)")
                    }
                    else
                    {
                        for document in QuerySnapshot!.documents
                        {
                            UserData.currentUser = document.data()["username"] as! String
                            print(UserData.currentUser)
                            print("current user")
                        }
                    }
                })
            
                //Signing in user
        }
        
        func showError(_ message:String) {
            
            errorLabel.text = message
            errorLabel.alpha = 1
        }
        
        func transitionToHome() {
            /*
            let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
            */
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        }
        
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { self.view.endEditing(true)
        return false
        
    }
}
