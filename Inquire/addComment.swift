//
//  addComment.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
class addComment: UIViewController, UITextViewDelegate {
    @IBOutlet weak var commentView: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        replieText.delegate = self
        replieText.textColor = UIColor.lightGray
        commentView.layer.borderColor = UIColor.lightGray.cgColor
        commentView.layer.borderWidth = 1
    }
    @IBOutlet weak var replieText: UITextView!
    lazy var functions = Functions.functions()
    @IBOutlet weak var submitReplyButton: UIButton!
     @IBAction func submitReply(_ sender: Any)
     {
         /*
        let channelName = UserData.currentChannel
        let questionID = UserData.currentQuestion
        let answerID = UserData.currentAnswer
        let replierID = UserData.currentUser
        let replietext = replieText.text!
        functions.httpsCallable("addReply").call(["channelName":channelName,"questionID":questionID,"answerID":answerID, "replierID":replierID,"replieText":replietext])
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
                print("join private worked")
        }
 */
        
     }
    
     func textViewDidBeginEditing(_ replieText: UITextView)
     {
        self.view.alpha = 0

        if !UserData.returnKeyboard
        {
            self.view.alpha = 1

        replieText.text = nil
        replieText.textColor = UIColor.black
        self.performSegue(withIdentifier: "toKeyboard", sender: self)
        }
        else
        {
            self.commentView.alpha = 0
            self.replieText.endEditing(true)
            self.commentView.endEditing(true)
            self.dismiss(animated:true, completion: nil)
            UserData.returnKeyboard = false
            //self.commentView.alpha = 1
            //self.view.alpha = 1

        }
     }
  
    @IBAction func didTapScreen(_ sender: Any)
    {
        dismiss(animated:true, completion: nil)
    }
    
}
