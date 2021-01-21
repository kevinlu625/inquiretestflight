//
//  deleteQuestionPopup.swift
//  Inquire
//
//  Created by Henry Liu on 8/17/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseAuth
class deleteQuestionPopup: UIViewController {

    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        deleteQuestionButton.roundedButton6()
        // Do any additional setup after loading the view.
        //cButton.layer.borderWidth = 1
        //cButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBOutlet weak var cButton: UIButton!    
    @IBOutlet weak var deleteQuestionButton: UIButton!
    @IBOutlet weak var deleteQuestionLabel: UILabel!
    lazy var functions = Functions.functions()
    @IBAction func deleteQuestionButton(_ sender: Any)
    {
        var channelname:String = UserData.currentChannel
        var questionText = UserData.currentQuestion
        let userid: String = UserData.currentUser
        let uid = Auth.auth().currentUser?.uid
        let True_Delete_False_Archive = true
        popupView.alpha = 0
        performSegue(withIdentifier: "deleteQuestionToLoading", sender: self)
        functions.httpsCallable("deleteQuestion").call(["channelName": channelname,"questionID":questionText, "userID":userid,"True_Delete_False_Archive":true,"uid":uid])
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
            print(channelname)
            print(userid)
            print(questionText)
              
        }

    }
        
        
        
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true
    , completion: nil)
    }
    
}

extension UIButton{
    func roundedButton6(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
