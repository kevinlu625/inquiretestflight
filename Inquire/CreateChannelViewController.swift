//
//  CreateChannelViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 8/8/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//


import UIKit
import GameKit
import FirebaseFunctions
import FirebaseCore
import FirebaseMessaging
import FirebaseAuth
import GoogleSignIn
import FirebaseInstanceID
import FirebaseFirestore
import UserNotifications 
import Foundation
class CreateChannelViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate
{
    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var createChannel: UIButton!
    @IBOutlet weak var channelCode: UILabel!
    @IBOutlet weak var channelBio: UITextView!
    
    lazy var functions = Functions.functions()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createChannel.layer.cornerRadius = 10
        channelBio.delegate = self
        channelBio.text = "Channel Description Here..."
        channelBio.textColor = UIColor.lightGray
        channelBio.delegate = self
        channelName.delegate = self
        channelBio.addingofDoneButton(title: 1.0, target: self, selector: #selector(tapDone(sender:)))
        channelName.addingofDoneButton(title: 1.0, target: self, selector: #selector(tapDone(sender:)))
        channelBio.layer.borderColor = UIColor.lightGray.cgColor
        channelName.layer.borderColor = UIColor.lightGray.cgColor
        channelBio.layer.borderWidth = 1
        channelBio.layer.cornerRadius = 10
        channelCode.layer.borderColor = UIColor.lightGray.cgColor
        channelCode.layer.borderWidth = 1
        channelCode.layer.cornerRadius = 10
        
    }
    var counter = 0
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if counter == 0
        {
            channelBio.text = nil
            channelBio.textColor = UIColor.black
            counter += 1
        }
    }

    @IBAction func enablePassword(_ sender: UISwitch)
    {
        if (sender.isOn == true)
        {
            channelCode.text = "\(channelCodeGenerator(length: 8))"
        }
        else
        {
            channelCode.text = ""
        }
    }
    
    func channelCodeGenerator(length: Int) -> String
    {
        let sourceString = "abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ123456789"
        var sequenceOfCharacters: [Character] = []
        for item in sourceString
        {
            sequenceOfCharacters.append(item)
        }
        var index = 1
        let passwordLength = 8
        var myPassword: [Character] = []
        let password: String
        var randomPositionPicker: Int
        while index <= passwordLength
        {
            randomPositionPicker = GKRandomSource.sharedRandom().nextInt(upperBound: sequenceOfCharacters.count)
            myPassword.append(sequenceOfCharacters[randomPositionPicker])
            index += 1
        }
        
        password = String(myPassword)
        return password
    }
    @IBAction func createChannelTapped(_ sender: Any)
    {
        self.errorLabel.text = ""
        var error = ""
        let db = Firestore.firestore()
        db.collection("Channels").whereField("ChannelName", isEqualTo: channelName.text).getDocuments(completion:
        { (QuerySnapshot, Error) in
            if let e = Error
            {
                print(e.localizedDescription)
            }
            for document in QuerySnapshot!.documents
            {
                if document.exists
                {
                    print("here1")
                    error = "channel name already taken"
                    print(error)
                    break
                }

            }
            print("here3")
            print(error)

            
        })
        if channelName.text == ""
        {
                error = "Please put a channel name"
            
            
        }
        else if channelCode.text == "" || channelCode.text == nil
        {
            error = "Please enable channel code"
        }
        else if channelBio.text == ""
        {
            error = "Please put in a channel bio"
        }
        
        print("right here")
        print(error)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false)
        {
           (Timer) in
            if error == ""
            {
            
               
                    let user = Auth.auth().currentUser
                    let uid = UserData.currentUser
                    print(self.channelName.text!)
                    UserData.currentChannel = self.channelName.text!
                    print("current user before create channel")
                    print(uid)
                    print(UserData.currentUser)
                    let name = self.channelName.text!
                    self.functions.httpsCallable("createChannel").call(["channelName": name, "channelCode":self.channelCode.text!,"uid":uid,"isPublic":false,"channelBio":self.channelBio.text])
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
                            Messaging.messaging().subscribe(toTopic: name as! String)
                            { error in
                                print("Subscribed to topic", self.channelName.text)
                               
                            }
                    }
                    print("create private worked")
            
                    }
                self.performSegue(withIdentifier: "toPopup2", sender: self)
                self.channelName.text = ""
                self.channelCode.text = ""
                self.channelBio.text = ""
                self.enableChannelCodeSwitch.isOn = false
                self.errorLabel.text = ""
            }
            else
            {
                self.errorLabel.text = error
            }
    }
        
    
}
    @IBOutlet weak var enableChannelCodeSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { self.view.endEditing(true)
        return false
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
         self.view.endEditing(true)
    }
    @objc func tapDone(sender: Any) {
          self.view.endEditing(true)
          dismiss(animated: true, completion: nil)
          dismiss(animated: true, completion: nil)
      }
    
}
extension UITextView {
    
    func addingofDoneButton(title: Double, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
   
}

extension UITextField
{
    func addingofDoneButton(title: Double, target: Any, selector: Selector) {
           
           let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                                 y: 0.0,
                                                 width: UIScreen.main.bounds.size.width,
                                                 height: 44.0))//1
           let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
           let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)//3
           toolBar.setItems([flexible, barButton], animated: false)//4
           self.inputAccessoryView = toolBar//5
       }
}
