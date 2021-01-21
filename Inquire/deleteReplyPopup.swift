//
//  deleteReplyPopup.swift
//  Inquire
//
//  Created by Henry Liu on 8/17/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
class deleteReplyPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        deleteButton.roundedButton4()
        print("ran")
        // Do any additional setup after loading the view.
        //cButton.layer.borderWidth = 1
        //cButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    lazy var functions = Functions.functions()

    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBAction func deleteReply(_ sender: Any) {
        
        let channelname =  UserData.currentChannel
               let questionID = UserData.currentQuestion
               
               let replyID =  UserData.currentReply
               let answerID = UserData.currentAnswer
               print(channelname)
               print(questionID)
        print(answerID)
        print(replyID)
        self.popupView.alpha = 0
        performSegue(withIdentifier: "deleteReplyToLoading", sender: self)
               functions.httpsCallable("deleteReply").call([ "channelName":channelname,"questionID":questionID,"replyID":replyID,"answerID":answerID])
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

                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                

                    print("delete answer worked")
            }
        
               

                   

    }
    

    @IBAction func cancelButton(_ sender: Any) {
           dismiss(animated: true
       , completion: nil)
       }

}

extension UIButton{
    func roundedButton4(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
