//
//  addCommentKeyBoard.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
class addCommentKeyBoard: UIViewController,UITextViewDelegate {
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var replieText: UITextView!
    lazy var functions = Functions.functions()
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        replieText.delegate = self
        replieText.textColor = UIColor.lightGray
        commentView.layer.borderColor = UIColor.lightGray.cgColor
        commentView.layer.borderWidth = 1
        if counter < 1
        {
            self.replieText.becomeFirstResponder()
            counter += 1
        }
        //replieText.addingDoneButton(title: 1.0, target: self, selector: #selector(tapDone(sender:)))
        if UserData.returnKeyboard
        {
            self.replieText.endEditing(true)
            dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)

            UserData.returnKeyboard = false
        }
       





        }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("comment")
            print(self.commentView.frame.origin.y)
            self.commentView.frame.origin.y = self.view.frame.height -            keyboardSize.height - 45
            print(self.commentView.frame.origin.y)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.commentView.frame.origin.y = 0
    }



   
        @IBOutlet weak var submitReplyButton: UIButton!
    
    
    
         @IBAction func submitReply(_ sender: Any)
         {
            let channelName = UserData.currentChannel
             let questionID = UserData.currentQuestion
             let answerID = UserData.currentAnswer
             let replierID = UserData.currentUser
            var replytext = replieText.text!
            replytext.censor()
            print("INDIGO")
            print(channelName)
            print(questionID)
            print(answerID)
            print(replierID)
            print(replytext)
            UserData.returnKeyboard = true
            performSegue(withIdentifier: "replyToLoading", sender: self)
            self.view.endEditing(true)
            self.replieText.alpha = 0
            
            functions.httpsCallable("addReply").call(["channelName":channelName,"questionID":questionID,"answerID":answerID,    "replierID":replierID,"replyText":replytext])
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
                        
                     }
                self.dismiss(animated: true, completion: nil)


                        print("add reply worked")
                

                              // Timer.invalidate()
             }


            //Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (Timer) in

               

        //}


         }
        
         func textViewDidBeginEditing(_ replieText: UITextView)
         {
            print(UserData.returnKeyboard)
            if UserData.returnKeyboard
            {
                print("this happened")
                //self.replieText.endEditing(true)
                dismiss(animated: true, completion: nil)
                //self.replieText.endEditing(true)
            }
            else{

            replieText.text = nil
            replieText.textColor = UIColor.black
            }
            
         }
    
        
    
    @IBAction func didTapScreen(_ sender: Any)
    {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
        
        
    }
    /*
    @objc func tapDone(sender: Any) {
           self.view.endEditing(true)
       }
 */
    
    
}
extension UITextView {
    
    func addingDoneButton(title: Double, target: Any, selector: Selector) {
        
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



