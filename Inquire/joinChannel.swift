//
//  joinChannel.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseCore
import FirebaseMessaging
import FirebaseAuth
import GoogleSignIn
import FirebaseInstanceID
import FirebaseFirestore
import UserNotifications 
class joinChannel: UIViewController, UITextFieldDelegate {
    lazy var functions = Functions.functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        joinChannelButton.layer.cornerRadius = 10
        channelCode.delegate = self
        channelCode.text = "channel code"
        channelCode.textColor = UIColor.lightGray
        channelCode.adDoneButton(title: 1.0, target: self, selector: #selector(tapDone(sender:)))

    }
    

    @IBOutlet weak var channelCode: UITextField!
    
    @IBOutlet weak var joinChannelButton: UIButton!
    var sentName = ""
    var sentSuccess = false
    @IBAction func joinChannel(_ sender: Any)
     {
         let userName = UserData.currentUser
         print( channelCode.text!)
        print(userName)
               //private channel
        self.performSegue(withIdentifier: "joinChannelToLoading", sender: self)
        functions.httpsCallable("joinChannel").call(["userName": userName, "Code":channelCode.text!,"isPublic":false,"channelID":""])
        {
            (result, error) in
                if let error = error as NSError?
                {
                    if error.domain == FunctionsErrorDomain
                    {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                    }
                    print("heere")
                    self.dismiss(animated: false, completion: nil)
                    DispatchQueue.main.async{
                        self.performSegue(withIdentifier: "toJoinChannelPopup", sender: self)
                    }
                    
                }
            var er = ""
            if let res = (result?.data as? [String:Any])?["error"] as? String
            {
               er = res
            }
            print("error")
            print(er)
            if(er != "empty"  )
            {
                self.sentSuccess = true
                Firestore.firestore().collection("Channels").whereField("ChannelCode", isEqualTo: self.channelCode.text).getDocuments
                { (QuerySnapshot, Error) in
                    for documents in QuerySnapshot!.documents
                    {
                        if documents.exists
                        {
                            if Error == nil
                            {
                                let dict = documents.data()
                                let channelName = dict["ChannelName"] as! String
                                self.sentName = channelName
                                Messaging.messaging().subscribe(toTopic: channelName as! String)
                                { error in
                                    print("Subscribed to topic", channelName)
                                   
                                }
                                
                            }
                        }
                        self.dismiss(animated: false, completion: nil)
                        DispatchQueue.main.async{
                            self.performSegue(withIdentifier: "toJoinChannelPopup", sender: self)
                        }
                        
                    }
                    print("join private worked")
                }
            }
            else if er == "empty"
            {
                self.dismiss(animated: false, completion: nil)
                DispatchQueue.main.async{
                    self.performSegue(withIdentifier: "toJoinChannelPopup", sender: self)
                }
            }

        }
        
        }
     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJoinChannelPopup"
        {
            channelCode.text = nil
            let vc = segue.destination as! joinChannelPopup
            vc.channelName = self.sentName
            vc.joinedSuccess = sentSuccess
            sentSuccess = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        channelCode.text = nil;
        channelCode.textColor = UIColor.black
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { self.view.endEditing(true)
        return false
        
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
}

extension UITextField {
    
    func adDoneButton(title: Double, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "done", style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
        
    }
}

    
        
        
    
