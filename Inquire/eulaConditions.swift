//
//  eulaConditions.swift
//  Inquire
//
//  Created by Henry Liu on 9/19/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCrashlytics
class eulaConditions: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func disagree(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var userName = ""
    var email = ""
    var password = ""

    @IBAction func agree(_ sender: Any) {
         
        userName.censor()
       
        print(userName)
        print(email)
        print(password)
        print("humanity")
        
        UserData.currentUser = userName
        UserData.currentChannel = "General"
        
        //Create the user
        Auth.auth().createUser(withEmail:email, password: password)
        { (result, err) in
                //User was created successfully, now store the first name and last name
            
            if let err = err
            {
                print(err.localizedDescription)
                Crashlytics.crashlytics().log(err.localizedDescription)
            }
            let db = Firestore.firestore()
            if let uid = result?.user.uid
            {

                db.collection("users").document(uid).setData(["username":self.userName, "uid":uid, "profileImg":"default", "email": self.email, "Points": 0])
                {
                    (error) in
                        
                    print("current username")
                    print(self.userName)
                }
            }
                
                //Transition to Home
                self.transitionToHome()
            
            
            
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp"
        {
            let vc = segue.destination as! SignUpViewController
            vc.didAgree = true
        }
    }
    func transitionToHome() {
        /*
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        */
        
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController") //REPLACE '"MainTabBarController"' with tabbed bar storyboard id
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

}
