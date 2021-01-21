//
//  deleteAnswerPopup.swift
//  Inquire
//
//  Created by Henry Liu on 8/17/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseAuth
class deleteAnswerPopup: UIViewController {

    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        deleteButton.roundedButton5()
        // Do any additional setup after loading the view.
        //cButton.layer.borderWidth = 1
        //cButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cButton: UIButton!
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    lazy var functions = Functions.functions()
    @IBAction func deleteAnswer(_ sender: Any)
    {
        let channelname =  UserData.currentChannel
               let questionID = UserData.currentQuestion
               let answerID = UserData.currentAnswer
        let uid = Auth.auth().currentUser?.uid
               print(channelname)
               print(questionID)
        popupView.alpha = 0

                 performSegue(withIdentifier: "deleteAnswerToLoading", sender: self)
        functions.httpsCallable("deleteAnswer").call([ "channelName":channelname,"questionID":questionID, "answerID":answerID,"uid":uid])
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
                                 print("delete answer worked")
                 self.dismiss(animated: true, completion: nil)

                               DispatchQueue.main.async {
                                   self.dismiss(animated: true, completion: nil)
                               }
                       }
     
              
    }


    @IBAction func cancelButton(_ sender: Any) {
           dismiss(animated: true
       , completion: nil)
       }

}

extension UIButton{
    func roundedButton5(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
